import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { InjectModel } from '@nestjs/mongoose';
import { randomBytes, randomUUID } from 'crypto';
import { Model } from 'mongoose';
import * as argon2 from 'argon2';
import { RefreshToken, RefreshTokenDocument } from '../database/schemas/refresh-token.schema';
import { User, UserDocument } from '../database/schemas/user.schema';
import { UserToken, UserTokenDocument } from '../database/schemas/user-token.schema';
import { AppError } from '../common/errors/app-error';
import { EventWriterService } from '../common/services/event-writer.service';
import { MongoTransactionService } from '../common/services/mongo-transaction.service';
import { hashToken } from '../common/utils/canonical-json';
import { addDays, addHours, addMinutes, isExpired } from '../common/utils/dates';
import { assertEmail, normalizeEmail } from '../common/utils/validation';
import {
  EMAIL_VERIFICATION_TTL_HOURS,
  PASSWORD_RESET_TTL_MINUTES,
  REFRESH_TOKEN_TTL_DAYS,
} from '../common/constants';
import {
  ChangePasswordDto,
  ForgotPasswordDto,
  LoginDto,
  RegisterDto,
  ResendVerificationDto,
  ResetPasswordDto,
} from './dto/auth.dto';

export interface PublicUser {
  id: string;
  name: string;
  email: string;
  emailVerified: boolean;
  notificationPreferences: Record<string, boolean>;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface SessionResult {
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
  user: PublicUser;
}

@Injectable()
export class AuthService {
  constructor(
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
    @InjectModel(RefreshToken.name)
    private readonly refreshTokenModel: Model<RefreshTokenDocument>,
    @InjectModel(UserToken.name) private readonly userTokenModel: Model<UserTokenDocument>,
    private readonly jwt: JwtService,
    private readonly config: ConfigService,
    private readonly transactions: MongoTransactionService,
    private readonly events: EventWriterService,
  ) {}

  async register(dto: RegisterDto, userAgent: string): Promise<SessionResult> {
    const emailNormalized = assertEmail(dto.email);
    const existing = await this.userModel.findOne({ emailNormalized }).lean().exec();
    if (existing) {
      throw AppError.conflict('EMAIL_IN_USE', 'An account with this email already exists');
    }

    const now = new Date();
    const passwordHash = await argon2.hash(dto.password, { type: argon2.argon2id });
    const userId = randomUUID();
    const rawVerificationToken = randomBytes(32).toString('base64url');

    const user = await this.transactions.run(async (session) => {
      const created = await this.userModel.create(
        [
          {
            _id: userId,
            name: dto.name.trim(),
            email: dto.email.trim(),
            emailNormalized,
            passwordHash,
            passwordChangedAt: now,
            emailVerifiedAt: null,
            notificationPreferences: {
              push: true,
              email: true,
              invitations: true,
              expenses: true,
              settlements: true,
            },
            syncVersion: 0,
            deletedAt: null,
          },
        ],
        { session },
      );

      await this.userTokenModel.create(
        [
          {
            _id: randomUUID(),
            userId,
            type: 'email_verification',
            tokenHash: hashToken(rawVerificationToken),
            expiresAt: addHours(now, EMAIL_VERIFICATION_TTL_HOURS),
            usedAt: null,
            revokedAt: null,
          },
        ],
        { session },
      );

      await this.events.queueEmail(session, {
        recipientUserId: userId,
        recipientEmail: emailNormalized,
        template: 'auth.email_verification',
        payload: {
          name: dto.name.trim(),
          token: rawVerificationToken,
          expiresInHours: EMAIL_VERIFICATION_TTL_HOURS,
        },
        dedupeKey: `auth.email_verification:${userId}:${randomUUID()}`,
      });

      return created[0];
    });

    return this.issueSession(user, dto.deviceId, userAgent);
  }

  async login(dto: LoginDto, userAgent: string): Promise<SessionResult> {
    const emailNormalized = normalizeEmail(dto.email);
    const user = await this.userModel
      .findOne({ emailNormalized })
      .select('+passwordHash')
      .exec();

    if (!user || user.deletedAt) {
      throw new AppError('AUTH_INVALID_CREDENTIALS', 'Invalid email or password', 401);
    }

    const valid = await argon2.verify(user.passwordHash, dto.password).catch(() => false);
    if (!valid) {
      throw new AppError('AUTH_INVALID_CREDENTIALS', 'Invalid email or password', 401);
    }

    return this.issueSession(user, dto.deviceId, userAgent);
  }

  async refresh(rawToken: string, userAgent: string): Promise<SessionResult> {
    const tokenHash = hashToken(rawToken);
    const stored = await this.refreshTokenModel.findOne({ tokenHash }).exec();
    if (!stored) {
      throw new AppError('AUTH_TOKEN_INVALID', 'The refresh token is invalid', 401);
    }

    if (stored.revokedAt) {
      await this.revokeFamily(stored.familyId, 'reuse_detected');
      throw new AppError(
        'AUTH_REFRESH_REUSED',
        'This session was already rotated. Sign in again.',
        401,
      );
    }

    if (isExpired(stored.expiresAt)) {
      await this.revokeFamily(stored.familyId, 'expired');
      throw new AppError('AUTH_TOKEN_EXPIRED', 'The refresh token has expired', 401);
    }

    const user = await this.userModel.findOne({ _id: stored.userId, deletedAt: null }).exec();
    if (!user) {
      await this.revokeFamily(stored.familyId, 'account_unavailable');
      throw new AppError('AUTH_TOKEN_INVALID', 'Session is no longer valid', 401);
    }

    const newRawToken = randomBytes(48).toString('base64url');
    const newHash = hashToken(newRawToken);
    const now = new Date();

    stored.revokedAt = now;
    stored.revokedReason = 'rotated';
    stored.replacedByTokenHash = newHash;
    stored.lastUsedAt = now;
    await stored.save();

    await this.refreshTokenModel.create({
      _id: randomUUID(),
      userId: user._id,
      familyId: stored.familyId,
      tokenHash: newHash,
      deviceId: stored.deviceId,
      userAgent,
      issuedAt: now,
      lastUsedAt: now,
      expiresAt: addDays(now, REFRESH_TOKEN_TTL_DAYS),
      revokedAt: null,
      revokedReason: null,
      replacedByTokenHash: null,
    });

    return {
      accessToken: await this.signAccessToken(user, stored.familyId),
      refreshToken: newRawToken,
      expiresIn: 15 * 60,
      user: this.toPublicUser(user),
    };
  }

  async logout(rawToken: string): Promise<null> {
    await this.refreshTokenModel.updateOne(
      { tokenHash: hashToken(rawToken), revokedAt: null },
      { $set: { revokedAt: new Date(), revokedReason: 'logout' } },
    );
    return null;
  }

  async logoutAll(userId: string): Promise<null> {
    await this.refreshTokenModel.updateMany(
      { userId, revokedAt: null },
      { $set: { revokedAt: new Date(), revokedReason: 'logout_all' } },
    );
    return null;
  }

  async verifyEmail(rawToken: string): Promise<PublicUser> {
    const tokenHash = hashToken(rawToken);
    const token = await this.userTokenModel.findOne({
      tokenHash,
      type: 'email_verification',
      usedAt: null,
      revokedAt: null,
    });
    if (!token || isExpired(token.expiresAt)) {
      throw new AppError('AUTH_TOKEN_INVALID', 'The verification token is invalid or expired', 400);
    }

    const user = await this.userModel.findOne({ _id: token.userId, deletedAt: null }).exec();
    if (!user) {
      throw new AppError('AUTH_TOKEN_INVALID', 'The verification token is invalid', 400);
    }

    const now = new Date();
    await this.transactions.run(async (session) => {
      token.usedAt = now;
      await token.save({ session });
      if (!user.emailVerifiedAt) {
        user.emailVerifiedAt = now;
        await user.save({ session });
      }
    });

    return this.toPublicUser(user);
  }

  async resendVerification(dto: ResendVerificationDto): Promise<null> {
    const emailNormalized = normalizeEmail(dto.email);
    const user = await this.userModel
      .findOne({ emailNormalized, deletedAt: null })
      .exec();

    if (!user || user.emailVerifiedAt) return null;

    const rawToken = randomBytes(32).toString('base64url');
    const now = new Date();
    await this.transactions.run(async (session) => {
      await this.userTokenModel.updateMany(
        { userId: user._id, type: 'email_verification', usedAt: null, revokedAt: null },
        { $set: { revokedAt: now } },
        { session },
      );
      await this.userTokenModel.create(
        [
          {
            _id: randomUUID(),
            userId: user._id,
            type: 'email_verification',
            tokenHash: hashToken(rawToken),
            expiresAt: addHours(now, EMAIL_VERIFICATION_TTL_HOURS),
            usedAt: null,
            revokedAt: null,
          },
        ],
        { session },
      );
      await this.events.queueEmail(session, {
        recipientUserId: user._id,
        recipientEmail: emailNormalized,
        template: 'auth.email_verification',
        payload: {
          name: user.name,
          token: rawToken,
          expiresInHours: EMAIL_VERIFICATION_TTL_HOURS,
        },
        dedupeKey: `auth.email_verification:${user._id}:${randomUUID()}`,
      });
    });

    return null;
  }

  async forgotPassword(dto: ForgotPasswordDto): Promise<null> {
    const emailNormalized = normalizeEmail(dto.email);
    const user = await this.userModel
      .findOne({ emailNormalized, deletedAt: null })
      .exec();

    if (!user) return null;

    const rawToken = randomBytes(32).toString('base64url');
    const now = new Date();
    await this.transactions.run(async (session) => {
      await this.userTokenModel.updateMany(
        { userId: user._id, type: 'password_reset', usedAt: null, revokedAt: null },
        { $set: { revokedAt: now } },
        { session },
      );
      await this.userTokenModel.create(
        [
          {
            _id: randomUUID(),
            userId: user._id,
            type: 'password_reset',
            tokenHash: hashToken(rawToken),
            expiresAt: addMinutes(now, PASSWORD_RESET_TTL_MINUTES),
            usedAt: null,
            revokedAt: null,
          },
        ],
        { session },
      );
      await this.events.queueEmail(session, {
        recipientUserId: user._id,
        recipientEmail: emailNormalized,
        template: 'auth.password_reset',
        payload: {
          name: user.name,
          token: rawToken,
          expiresInMinutes: PASSWORD_RESET_TTL_MINUTES,
        },
        dedupeKey: `auth.password_reset:${user._id}:${randomUUID()}`,
      });
    });

    return null;
  }

  async resetPassword(dto: ResetPasswordDto): Promise<null> {
    const tokenHash = hashToken(dto.token);
    const token = await this.userTokenModel.findOne({
      tokenHash,
      type: 'password_reset',
      usedAt: null,
      revokedAt: null,
    });
    if (!token || isExpired(token.expiresAt)) {
      throw new AppError('AUTH_TOKEN_INVALID', 'The password reset token is invalid or expired', 400);
    }

    const user = await this.userModel.findOne({ _id: token.userId, deletedAt: null }).exec();
    if (!user) {
      throw new AppError('AUTH_TOKEN_INVALID', 'The password reset token is invalid', 400);
    }

    const passwordHash = await argon2.hash(dto.newPassword, { type: argon2.argon2id });
    const now = new Date();

    await this.transactions.run(async (session) => {
      await this.userModel.updateOne(
        { _id: user._id },
        { $set: { passwordHash, passwordChangedAt: now } },
        { session },
      );
      token.usedAt = now;
      await token.save({ session });
      await this.refreshTokenModel.updateMany(
        { userId: user._id, revokedAt: null },
        { $set: { revokedAt: now, revokedReason: 'password_reset' } },
        { session },
      );
      await this.userTokenModel.updateMany(
        {
          userId: user._id,
          type: 'password_reset',
          _id: { $ne: token._id },
          usedAt: null,
          revokedAt: null,
        },
        { $set: { revokedAt: now } },
        { session },
      );
    });

    return null;
  }

  async changePassword(
    userId: string,
    familyId: string,
    dto: ChangePasswordDto,
  ): Promise<null> {
    const user = await this.userModel
      .findOne({ _id: userId, deletedAt: null })
      .select('+passwordHash')
      .exec();
    if (!user) throw new AppError('AUTH_TOKEN_INVALID', 'Session is no longer valid', 401);

    const valid = await argon2.verify(user.passwordHash, dto.currentPassword).catch(() => false);
    if (!valid) {
      throw new AppError('AUTH_INVALID_CREDENTIALS', 'The current password is incorrect', 401);
    }

    const passwordHash = await argon2.hash(dto.newPassword, { type: argon2.argon2id });
    const now = new Date();

    await this.transactions.run(async (session) => {
      await this.userModel.updateOne(
        { _id: user._id },
        { $set: { passwordHash, passwordChangedAt: now } },
        { session },
      );
      await this.refreshTokenModel.updateMany(
        { userId: user._id, familyId: { $ne: familyId }, revokedAt: null },
        { $set: { revokedAt: now, revokedReason: 'password_changed' } },
        { session },
      );
    });

    return null;
  }

  private async issueSession(
    user: UserDocument,
    deviceId: string | undefined,
    userAgent: string,
  ): Promise<SessionResult> {
    const familyId = randomUUID();
    const rawToken = randomBytes(48).toString('base64url');
    const now = new Date();

    await this.refreshTokenModel.create({
      _id: randomUUID(),
      userId: user._id,
      familyId,
      tokenHash: hashToken(rawToken),
      deviceId: deviceId ?? randomUUID(),
      userAgent,
      issuedAt: now,
      lastUsedAt: now,
      expiresAt: addDays(now, REFRESH_TOKEN_TTL_DAYS),
      revokedAt: null,
      revokedReason: null,
      replacedByTokenHash: null,
    });

    return {
      accessToken: await this.signAccessToken(user, familyId),
      refreshToken: rawToken,
      expiresIn: 15 * 60,
      user: this.toPublicUser(user),
    };
  }

  private async signAccessToken(user: UserDocument, familyId: string): Promise<string> {
    return this.jwt.signAsync({
      sub: user._id,
      familyId,
      pwc: Math.floor(user.passwordChangedAt.getTime() / 1000),
    });
  }

  private async revokeFamily(familyId: string, reason: string): Promise<void> {
    await this.refreshTokenModel.updateMany(
      { familyId, revokedAt: null },
      { $set: { revokedAt: new Date(), revokedReason: reason } },
    );
  }

  toPublicUser(user: UserDocument): PublicUser {
    return {
      id: user._id,
      name: user.name,
      email: user.email,
      emailVerified: Boolean(user.emailVerifiedAt),
      notificationPreferences: user.notificationPreferences as unknown as Record<string, boolean>,
      createdAt: (user as unknown as { createdAt?: Date }).createdAt,
      updatedAt: (user as unknown as { updatedAt?: Date }).updatedAt,
    };
  }
}
