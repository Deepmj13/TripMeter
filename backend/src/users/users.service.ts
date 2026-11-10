import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { randomBytes, randomUUID } from 'crypto';
import { Model } from 'mongoose';
import * as argon2 from 'argon2';
import { AppError } from '../common/errors/app-error';
import { EventWriterService } from '../common/services/event-writer.service';
import { MongoTransactionService } from '../common/services/mongo-transaction.service';
import { assertEmail, normalizeEmail } from '../common/utils/validation';
import { AuthService, PublicUser } from '../auth/auth.service';
import { DeviceToken, DeviceTokenDocument } from '../database/schemas/device-token.schema';
import { RefreshToken, RefreshTokenDocument } from '../database/schemas/refresh-token.schema';
import { Trip, TripDocument } from '../database/schemas/trip.schema';
import { TripInvitation, TripInvitationDocument } from '../database/schemas/trip-invitation.schema';
import { TripMember, TripMemberDocument } from '../database/schemas/trip-member.schema';
import { User, UserDocument } from '../database/schemas/user.schema';
import { UserToken, UserTokenDocument } from '../database/schemas/user-token.schema';
import { DeleteAccountDto, UpdateProfileDto } from './dto/users.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
    @InjectModel(RefreshToken.name)
    private readonly refreshTokenModel: Model<RefreshTokenDocument>,
    @InjectModel(UserToken.name) private readonly userTokenModel: Model<UserTokenDocument>,
    @InjectModel(Trip.name) private readonly tripModel: Model<TripDocument>,
    @InjectModel(TripMember.name) private readonly memberModel: Model<TripMemberDocument>,
    @InjectModel(TripInvitation.name)
    private readonly invitationModel: Model<TripInvitationDocument>,
    @InjectModel(DeviceToken.name)
    private readonly deviceModel: Model<DeviceTokenDocument>,
    private readonly auth: AuthService,
    private readonly events: EventWriterService,
    private readonly transactions: MongoTransactionService,
  ) {}

  async me(userId: string): Promise<PublicUser> {
    const user = await this.userModel.findOne({ _id: userId, deletedAt: null }).exec();
    if (!user) throw new AppError('AUTH_TOKEN_INVALID', 'Session is no longer valid', 401);
    return this.auth.toPublicUser(user);
  }

  async updateProfile(userId: string, dto: UpdateProfileDto): Promise<PublicUser> {
    const user = await this.userModel
      .findOne({ _id: userId, deletedAt: null })
      .select('+passwordHash')
      .exec();
    if (!user) throw new AppError('AUTH_TOKEN_INVALID', 'Session is no longer valid', 401);

    if (dto.name !== undefined) user.name = dto.name.trim();

    if (dto.notificationPreferences) {
      user.notificationPreferences = {
        ...user.notificationPreferences,
        ...dto.notificationPreferences,
      };
    }

    if (dto.email && normalizeEmail(dto.email) !== user.emailNormalized) {
      if (!dto.currentPassword) {
        throw AppError.validation('currentPassword is required to change the email address');
      }
      const valid = await argon2
        .verify(user.passwordHash, dto.currentPassword)
        .catch(() => false);
      if (!valid) {
        throw new AppError('AUTH_INVALID_CREDENTIALS', 'The current password is incorrect', 401);
      }

      const emailNormalized = assertEmail(dto.email);
      const conflict = await this.userModel
        .findOne({ emailNormalized, _id: { $ne: userId } })
        .lean()
        .exec();
      if (conflict) {
        throw AppError.conflict('EMAIL_IN_USE', 'An account with this email already exists');
      }

      user.email = dto.email.trim();
      user.emailNormalized = emailNormalized;

      await this.memberModel.updateMany(
        { userId, status: 'active' },
        { $set: { displayName: user.name, emailNormalized } },
      );
    }

    await user.save();
    return this.auth.toPublicUser(user);
  }

  async sessions(userId: string) {
    const now = new Date();
    const tokens = await this.refreshTokenModel
      .find({ userId, revokedAt: null, expiresAt: { $gt: now } })
      .sort({ lastUsedAt: -1 })
      .lean()
      .exec();

    const seen = new Set<string>();
    return tokens
      .filter((token) => {
        if (seen.has(token.familyId)) return false;
        seen.add(token.familyId);
        return true;
      })
      .map((token) => ({
        sessionId: token.familyId,
        deviceId: token.deviceId,
        userAgent: token.userAgent,
        issuedAt: token.issuedAt,
        lastUsedAt: token.lastUsedAt,
        expiresAt: token.expiresAt,
      }));
  }

  async revokeSession(userId: string, sessionId: string): Promise<null> {
    await this.refreshTokenModel.updateMany(
      { userId, familyId: sessionId, revokedAt: null },
      { $set: { revokedAt: new Date(), revokedReason: 'session_revoked' } },
    );
    return null;
  }

  async deleteAccount(userId: string, dto: DeleteAccountDto): Promise<null> {
    const user = await this.userModel
      .findOne({ _id: userId, deletedAt: null })
      .select('+passwordHash')
      .exec();
    if (!user) throw new AppError('AUTH_TOKEN_INVALID', 'Session is no longer valid', 401);

    const valid = await argon2.verify(user.passwordHash, dto.password).catch(() => false);
    if (!valid) {
      throw new AppError('AUTH_INVALID_CREDENTIALS', 'The password is incorrect', 401);
    }

    const ownedTrips = await this.tripModel.find({ ownerUserId: userId }).lean().exec();
    for (const trip of ownedTrips) {
      const otherActiveMembers = await this.memberModel
        .countDocuments({
          tripId: trip._id,
          userId: { $ne: userId },
          status: 'active',
        })
        .exec();
      if (otherActiveMembers > 0) {
        throw AppError.conflict(
          'VALIDATION_ERROR',
          'Transfer ownership of every trip with other active members before deleting your account',
          { tripId: trip._id },
        );
      }
    }

    const now = new Date();
    const anonymizedEmail = `deleted+${randomUUID()}@invalid.local`;
    const linkedMemberships = await this.memberModel.find({ userId }).lean().exec();

    await this.transactions.run(async (session) => {
      await this.userModel.updateOne(
        { _id: userId },
        {
          $set: {
            name: 'Deleted user',
            email: anonymizedEmail,
            emailNormalized: anonymizedEmail,
            passwordHash: await argon2.hash(randomBytes(32).toString('hex')),
            deletedAt: now,
            syncVersion: 0,
          },
        },
        { session },
      );

      await this.refreshTokenModel.updateMany(
        { userId, revokedAt: null },
        { $set: { revokedAt: now, revokedReason: 'account_deleted' } },
        { session },
      );
      await this.deviceModel.updateMany(
        { userId, revokedAt: null },
        { $set: { revokedAt: now } },
        { session },
      );
      await this.userTokenModel.updateMany(
        { userId, usedAt: null, revokedAt: null },
        { $set: { revokedAt: now } },
        { session },
      );
      await this.invitationModel.updateMany(
        { emailNormalized: user.emailNormalized, status: 'pending' },
        { $set: { status: 'revoked', revokedAt: now, respondedAt: now } },
        { session },
      );

      for (const membership of linkedMemberships) {
        await this.memberModel.updateOne(
          { _id: membership._id },
          {
            $set: {
              displayName: 'Deleted user',
              emailNormalized: null,
              userId: null,
              memberKind: 'guest',
            },
          },
          { session },
        );
        await this.events.appendTripEvent(session, {
          tripId: membership.tripId,
          eventType: 'member.updated',
          entityType: 'member',
          entityId: membership._id,
          actorUserId: userId,
          payload: {
            id: membership._id,
            tripId: membership.tripId,
            displayName: 'Deleted user',
            memberKind: 'guest',
            role: membership.role,
            status: membership.status,
            userId: null,
          },
        });
      }

      await this.events.appendUserEvent(session, {
        userId,
        eventType: 'account.deleted',
        payload: { userId },
      });
    });

    return null;
  }
}
