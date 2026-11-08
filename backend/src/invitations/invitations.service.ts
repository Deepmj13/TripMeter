import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { ClientSession, Model } from 'mongoose';
import { randomBytes, randomUUID } from 'crypto';
import { AppError } from '../common/errors/app-error';
import { EventWriterService } from '../common/services/event-writer.service';
import { IdempotencyService } from '../common/services/idempotency.service';
import { hashRequest, hashToken } from '../common/utils/canonical-json';
import { INVITATION_TTL_DAYS } from '../common/constants';
import { addDays, isExpired } from '../common/utils/dates';
import { assertEmail, normalizeEmail } from '../common/utils/validation';
import { memberSnapshot } from '../common/serializers';
import {
  TripInvitation,
  TripInvitationDocument,
} from '../database/schemas/trip-invitation.schema';
import { TripMember, TripMemberDocument } from '../database/schemas/trip-member.schema';
import { Trip, TripDocument } from '../database/schemas/trip.schema';
import { User, UserDocument } from '../database/schemas/user.schema';
import { TripAccessService } from '../trips/trip-access.service';
import { CreateInvitationDto } from '../trips/dto/trips.dto';

function invitationSnapshot(invitation: TripInvitationDocument): Record<string, unknown> {
  return {
    id: invitation._id,
    tripId: invitation.tripId,
    memberId: invitation.memberId,
    invitedByUserId: invitation.invitedByUserId,
    email: invitation.emailNormalized,
    status: invitation.status,
    expiresAt: invitation.expiresAt,
    acceptedAt: invitation.acceptedAt,
    respondedAt: invitation.respondedAt,
    createdAt: (invitation as unknown as { createdAt?: Date }).createdAt,
    updatedAt: (invitation as unknown as { updatedAt?: Date }).updatedAt,
  };
}

@Injectable()
export class InvitationsService {
  constructor(
    @InjectModel(TripInvitation.name)
    private readonly invitationModel: Model<TripInvitationDocument>,
    @InjectModel(TripMember.name) private readonly memberModel: Model<TripMemberDocument>,
    @InjectModel(Trip.name) private readonly tripModel: Model<TripDocument>,
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
    private readonly access: TripAccessService,
    private readonly events: EventWriterService,
    private readonly idempotency: IdempotencyService,
  ) {}

  async create(
    tripId: string,
    actorUserId: string,
    dto: CreateInvitationDto,
    idempotencyKey?: string,
  ) {
    const requestHash = hashRequest('POST', `/v1/trips/${tripId}/invitations`, dto);
    return this.idempotency.execute(
      actorUserId,
      idempotencyKey,
      requestHash,
      async (session) => {
        const { trip, member: actor } = await this.access.requireMembership(
          tripId,
          actorUserId,
          session,
        );
        this.access.requireRole(actor, ['owner', 'admin']);
        if (trip.archivedAt) {
          throw AppError.conflict('TRIP_ARCHIVED', 'This trip is archived');
        }

        const email = assertEmail(dto.email);

        const activeMatch = await this.memberModel
          .findOne({ tripId, emailNormalized: email, status: 'active' }, null, { session })
          .lean()
          .exec();
        if (activeMatch) {
          throw AppError.conflict(
            'MEMBER_NOT_ELIGIBLE',
            'This email already belongs to an active member of the trip',
          );
        }

        let member = await this.memberModel
          .findOne({ tripId, emailNormalized: email }, null, { session })
          .exec();

        if (!member) {
          member = (
            await this.memberModel.create(
              [
                {
                  _id: randomUUID(),
                  tripId,
                  userId: null,
                  displayName: email.split('@')[0],
                  emailNormalized: email,
                  memberKind: 'account',
                  role: 'member',
                  status: 'invited',
                  createdByUserId: actorUserId,
                  joinedAt: null,
                },
              ],
              { session },
            )
          )[0];
        }

        const existingPending = await this.invitationModel
          .findOne({ tripId, emailNormalized: email, status: 'pending' }, null, { session })
          .exec();

        const rawToken = randomBytes(32).toString('base64url');
        const now = new Date();
        const expiresAt = addDays(now, INVITATION_TTL_DAYS);

        let invitation: TripInvitationDocument;
        if (existingPending) {
          existingPending.tokenHash = hashToken(rawToken);
          existingPending.expiresAt = expiresAt;
          await existingPending.save({ session });
          invitation = existingPending;
        } else {
          invitation = (
            await this.invitationModel.create(
              [
                {
                  _id: randomUUID(),
                  tripId,
                  memberId: member._id,
                  invitedByUserId: actorUserId,
                  emailNormalized: email,
                  tokenHash: hashToken(rawToken),
                  status: 'pending',
                  expiresAt,
                  acceptedAt: null,
                  respondedAt: null,
                  revokedAt: null,
                },
              ],
              { session },
            )
          )[0];
        }

        await this.events.queueEmail(session, {
          recipientUserId: null,
          recipientEmail: email,
          template: 'invitation.created',
          payload: {
            invitationId: invitation._id,
            tripId,
            tripName: trip.name,
            inviterName: actor.displayName,
            token: rawToken,
            expiresAt,
          },
          dedupeKey: `invitation.created:${invitation._id}:${randomUUID()}`,
        });

        const invitee = await this.userModel
          .findOne({ emailNormalized: email, deletedAt: null }, null, { session })
          .lean()
          .exec();
        if (invitee) {
          await this.events.appendUserEvent(session, {
            userId: invitee._id,
            eventType: 'invitation.created',
            tripId,
            payload: { invitationId: invitation._id, tripId, status: 'pending' },
          });
        }

        return {
          status: 201,
          body: { ...invitationSnapshot(invitation), tripName: trip.name },
        };
      },
    );
  }

  async list(userId: string) {
    const user = await this.userModel.findById(userId).lean().exec();
    if (!user) return { items: [] };

    const invitations = await this.invitationModel
      .find({ emailNormalized: user.emailNormalized })
      .sort({ createdAt: -1 })
      .lean()
      .exec();

    const tripIds = [...new Set(invitations.map((invitation) => invitation.tripId))];
    const trips = await this.tripModel
      .find({ _id: { $in: tripIds } })
      .lean()
      .exec();
    const tripNames = new Map(trips.map((trip) => [trip._id, trip.name]));

    return {
      items: invitations.map((invitation) => ({
        ...invitationSnapshot(invitation as unknown as TripInvitationDocument),
        tripName: tripNames.get(invitation.tripId) ?? null,
      })),
    };
  }

  async get(userId: string, invitationId: string) {
    const invitation = await this.invitationModel.findById(invitationId).exec();
    if (!invitation) throw AppError.notFound('TRIP_NOT_FOUND', 'Invitation not found');

    const user = await this.userModel.findById(userId).lean().exec();
    if (user && user.emailNormalized === invitation.emailNormalized) {
      return invitationSnapshot(invitation);
    }

    try {
      const { member } = await this.access.requireMembership(invitation.tripId, userId);
      this.access.requireRole(member, ['owner', 'admin']);
      return invitationSnapshot(invitation);
    } catch {
      throw AppError.notFound('TRIP_NOT_FOUND', 'Invitation not found');
    }
  }

  async resend(userId: string, invitationId: string, idempotencyKey?: string) {
    const requestHash = hashRequest(
      'POST',
      `/v1/invitations/${invitationId}/resend`,
      {},
    );
    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const invitation = await this.invitationModel
        .findOne({ _id: invitationId, status: 'pending' })
        .session(session)
        .exec();
      if (!invitation) {
        throw AppError.conflict('INVITATION_INVALID', 'This invitation is not pending');
      }

      const { member } = await this.access.requireMembership(
        invitation.tripId,
        userId,
        session,
      );
      this.access.requireRole(member, ['owner', 'admin']);

      const trip = await this.tripModel
        .findById(invitation.tripId)
        .session(session)
        .lean()
        .exec();
      if (!trip) throw AppError.notFound('TRIP_NOT_FOUND', 'Trip not found');

      const rawToken = randomBytes(32).toString('base64url');
      const expiresAt = addDays(new Date(), INVITATION_TTL_DAYS);
      invitation.tokenHash = hashToken(rawToken);
      invitation.expiresAt = expiresAt;
      await invitation.save({ session });

      await this.events.queueEmail(session, {
        recipientEmail: invitation.emailNormalized,
        template: 'invitation.created',
        payload: {
          invitationId: invitation._id,
          tripId: invitation.tripId,
          tripName: trip.name,
          inviterName: member.displayName,
          token: rawToken,
          expiresAt,
        },
        dedupeKey: `invitation.resend:${invitation._id}:${randomUUID()}`,
      });

      const invitee = await this.userModel
        .findOne({ emailNormalized: invitation.emailNormalized, deletedAt: null }, null, {
          session,
        })
        .lean()
        .exec();
      if (invitee) {
        await this.events.appendUserEvent(session, {
          userId: invitee._id,
          eventType: 'invitation.updated',
          tripId: invitation.tripId,
          payload: {
            invitationId: invitation._id,
            tripId: invitation.tripId,
            status: 'pending',
          },
        });
      }

      return { status: 200, body: invitationSnapshot(invitation) };
    });
  }

  async revoke(userId: string, invitationId: string, idempotencyKey?: string) {
    const requestHash = hashRequest(
      'POST',
      `/v1/invitations/${invitationId}/revoke`,
      {},
    );
    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const invitation = await this.invitationModel
        .findOne({ _id: invitationId, status: 'pending' })
        .session(session)
        .exec();
      if (!invitation) {
        throw AppError.conflict('INVITATION_INVALID', 'This invitation is not pending');
      }

      const { member } = await this.access.requireMembership(
        invitation.tripId,
        userId,
        session,
      );
      this.access.requireRole(member, ['owner', 'admin']);

      const now = new Date();
      invitation.status = 'revoked';
      invitation.revokedAt = now;
      invitation.respondedAt = now;
      await invitation.save({ session });
      await this.cancelProvisionalMember(session, invitation);

      const invitee = await this.userModel
        .findOne({ emailNormalized: invitation.emailNormalized, deletedAt: null }, null, {
          session,
        })
        .lean()
        .exec();
      if (invitee) {
        await this.events.appendUserEvent(session, {
          userId: invitee._id,
          eventType: 'invitation.updated',
          tripId: invitation.tripId,
          payload: {
            invitationId: invitation._id,
            tripId: invitation.tripId,
            status: 'revoked',
          },
        });
      }

      return { status: 200, body: invitationSnapshot(invitation) };
    });
  }

  async acceptById(userId: string, invitationId: string, idempotencyKey?: string) {
    const requestHash = hashRequest(
      'POST',
      `/v1/invitations/${invitationId}/accept`,
      {},
    );
    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const invitation = await this.invitationModel
        .findById(invitationId)
        .session(session)
        .exec();
      if (!invitation) throw AppError.notFound('TRIP_NOT_FOUND', 'Invitation not found');
      return this.acceptInvitation(session, invitation, userId);
    });
  }

  async acceptByToken(userId: string, token: string, idempotencyKey?: string) {
    const requestHash = hashRequest('POST', '/v1/invitations/accept', { token });
    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const invitation = await this.invitationModel
        .findOne({ tokenHash: hashToken(token), status: 'pending' })
        .session(session)
        .exec();
      if (!invitation) {
        throw AppError.conflict('INVITATION_INVALID', 'This invitation is invalid or expired');
      }
      return this.acceptInvitation(session, invitation, userId);
    });
  }

  async decline(userId: string, token?: string, invitationId?: string) {
    if (!token && !invitationId) {
      throw AppError.validation('Provide an invitation token or invitationId');
    }

    const invitation = invitationId
      ? await this.invitationModel.findById(invitationId).exec()
      : await this.invitationModel
          .findOne({ tokenHash: hashToken(token!), status: 'pending' })
          .exec();

    if (!invitation) throw AppError.notFound('TRIP_NOT_FOUND', 'Invitation not found');
    if (invitation.status !== 'pending') {
      throw AppError.conflict('INVITATION_INVALID', 'This invitation is no longer pending');
    }
    if (isExpired(invitation.expiresAt)) {
      await this.expireInvitation(invitation);
      throw AppError.conflict('INVITATION_INVALID', 'This invitation has expired');
    }

    const user = await this.userModel.findById(userId).lean().exec();
    if (!user || user.emailNormalized !== invitation.emailNormalized) {
      throw AppError.forbidden();
    }

    const now = new Date();
    invitation.status = 'declined';
    invitation.respondedAt = now;
    await invitation.save();
    await this.cancelProvisionalMember(null, invitation);
    await this.events.appendUserEvent(null as unknown as ClientSession, {
      userId,
      eventType: 'invitation.updated',
      tripId: invitation.tripId,
      payload: {
        invitationId: invitation._id,
        tripId: invitation.tripId,
        status: 'declined',
      },
    });

    return { declined: true, invitationId: invitation._id };
  }

  private async acceptInvitation(
    session: ClientSession,
    invitation: TripInvitationDocument,
    userId: string,
  ) {
    if (invitation.status !== 'pending') {
      throw AppError.conflict('INVITATION_INVALID', 'This invitation is no longer pending');
    }
    if (isExpired(invitation.expiresAt)) {
      throw AppError.conflict('INVITATION_INVALID', 'This invitation has expired');
    }

    const user = await this.userModel.findById(userId).session(session).exec();
    if (!user?.emailVerifiedAt) {
      throw new AppError(
        'AUTH_EMAIL_UNVERIFIED',
        'Verify your email before accepting an invitation',
        403,
      );
    }
    if (normalizeEmail(user.emailNormalized) !== invitation.emailNormalized) {
      throw AppError.forbidden();
    }

    const trip = await this.tripModel
      .findById(invitation.tripId)
      .session(session)
      .exec();
    if (!trip) throw AppError.notFound('TRIP_NOT_FOUND', 'Trip not found');

    const otherMembership = await this.memberModel
      .findOne(
        { tripId: invitation.tripId, userId, _id: { $ne: invitation.memberId } },
        null,
        { session },
      )
      .lean()
      .exec();
    if (otherMembership) {
      throw AppError.conflict(
        'MEMBER_NOT_ELIGIBLE',
        'You already have a membership record in this trip',
      );
    }

    const member = await this.memberModel
      .findById(invitation.memberId)
      .session(session)
      .exec();
    if (!member) throw AppError.notFound('TRIP_NOT_FOUND', 'Member not found');
    if (member.emailNormalized !== invitation.emailNormalized) {
      throw AppError.conflict('INVITATION_INVALID', 'The invitation does not match this membership');
    }

    const now = new Date();
    member.userId = userId;
    member.memberKind = 'account';
    member.status = 'active';
    member.joinedAt = now;
    member.displayName = user.name;
    member.emailNormalized = user.emailNormalized;
    await member.save({ session });

    invitation.status = 'accepted';
    invitation.acceptedAt = now;
    invitation.respondedAt = now;
    await invitation.save({ session });

    await this.events.appendTripEvent(session, {
      tripId: invitation.tripId,
      eventType: 'member.updated',
      entityType: 'member',
      entityId: member._id,
      actorUserId: userId,
      payload: memberSnapshot(member),
    });
    await this.events.appendUserEvent(session, {
      userId,
      eventType: 'trip.access.granted',
      tripId: invitation.tripId,
      payload: { tripId: invitation.tripId, memberId: member._id, role: member.role },
    });

    return {
      status: 200,
      body: {
        invitation: invitationSnapshot(invitation),
        membership: memberSnapshot(member),
        tripId: invitation.tripId,
      },
    };
  }

  private async cancelProvisionalMember(
    session: ClientSession | null,
    invitation: TripInvitationDocument,
  ): Promise<void> {
    const member = await this.memberModel
      .findOne({ _id: invitation.memberId, status: 'invited' })
      .session(session)
      .exec();
    if (member) {
      member.status = 'removed';
      await member.save({ session: session ?? undefined });
    }
  }

  private async expireInvitation(invitation: TripInvitationDocument): Promise<void> {
    if (invitation.status !== 'pending') return;
    invitation.status = 'expired';
    invitation.respondedAt = new Date();
    await invitation.save();
    await this.cancelProvisionalMember(null, invitation);
  }
}
