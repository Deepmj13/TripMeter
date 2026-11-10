import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { randomUUID } from 'crypto';
import { AppError } from '../common/errors/app-error';
import { EventWriterService } from '../common/services/event-writer.service';
import { IdempotencyService } from '../common/services/idempotency.service';
import { hashRequest } from '../common/utils/canonical-json';
import { MAX_TRIP_MEMBERS } from '../common/constants';
import { assertEmail, assertUuid, normalizeEmail } from '../common/utils/validation';
import { memberSnapshot } from '../common/serializers';
import { TripMember, TripMemberDocument } from '../database/schemas/trip-member.schema';
import { User, UserDocument } from '../database/schemas/user.schema';
import {
  ChangeRoleDto,
  CreateGuestMemberDto,
  UpdateMemberDto,
} from '../trips/dto/trips.dto';
import { TripAccessService } from '../trips/trip-access.service';

@Injectable()
export class MembersService {
  constructor(
    @InjectModel(TripMember.name) private readonly memberModel: Model<TripMemberDocument>,
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
    private readonly access: TripAccessService,
    private readonly events: EventWriterService,
    private readonly idempotency: IdempotencyService,
  ) {}

  async list(tripId: string, userId: string) {
    const { member: actor } = await this.access.requireMembership(tripId, userId);
    const members = await this.memberModel
      .find({ tripId })
      .sort({ status: 1, displayName: 1 })
      .lean()
      .exec();

    const canSeeEmails = actor.role === 'owner' || actor.role === 'admin';
    return {
      items: members.map((member) => ({
        ...memberSnapshot(member as unknown as TripMemberDocument),
        ...(canSeeEmails || member.userId === userId
          ? { email: member.emailNormalized }
          : {}),
      })),
    };
  }

  async get(tripId: string, userId: string, memberId: string) {
    const { member: actor } = await this.access.requireMembership(tripId, userId);
    const member = await this.memberModel.findOne({ _id: memberId, tripId }).exec();
    if (!member) throw AppError.notFound('TRIP_NOT_FOUND', 'Member not found');

    const canSeeEmail =
      actor.role === 'owner' || actor.role === 'admin' || member.userId === userId;
    return {
      ...memberSnapshot(member),
      ...(canSeeEmail ? { email: member.emailNormalized } : {}),
    };
  }

  async addGuest(
    tripId: string,
    userId: string,
    dto: CreateGuestMemberDto,
    idempotencyKey?: string,
  ) {
    const requestHash = hashRequest('POST', `/v1/trips/${tripId}/members`, dto);
    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const { trip, member: actor } = await this.access.requireMembership(
        tripId,
        userId,
        session,
      );
      this.access.requireRole(actor, ['owner', 'admin']);
      this.access.assertWritable(trip);

      const count = await this.memberModel
        .countDocuments({ tripId, status: { $ne: 'removed' } })
        .session(session)
        .exec();
      if (count >= MAX_TRIP_MEMBERS) {
        throw AppError.validation(`A trip may have at most ${MAX_TRIP_MEMBERS} members`);
      }

      const email = dto.email ? assertEmail(dto.email) : null;
      if (email) {
        const duplicate = await this.memberModel
          .findOne({ tripId, emailNormalized: email }, null, { session })
          .lean()
          .exec();
        if (duplicate) {
          throw AppError.conflict(
            'EMAIL_IN_USE',
            'A member with this email already exists in the trip',
          );
        }
      }

      const member = (
        await this.memberModel.create(
          [
            {
              _id: dto.id ? assertUuid(dto.id, 'id') : randomUUID(),
              tripId,
              userId: null,
              displayName: dto.displayName.trim(),
              emailNormalized: email,
              memberKind: 'guest',
              role: 'member',
              status: 'active',
              createdByUserId: userId,
              joinedAt: null,
            },
          ],
          { session },
        )
      )[0];

      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'member.added',
        entityType: 'member',
        entityId: member._id,
        actorUserId: userId,
        payload: memberSnapshot(member),
      });

      return {
        status: 201,
        body: {
          ...memberSnapshot(member),
          ...(email ? { email } : {}),
        },
      };
    });
  }

  async update(
    tripId: string,
    userId: string,
    memberId: string,
    dto: UpdateMemberDto,
    idempotencyKey?: string,
  ) {
    const requestHash = hashRequest(
      'PATCH',
      `/v1/trips/${tripId}/members/${memberId}`,
      dto,
    );
    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const { trip, member: actor } = await this.access.requireMembership(
        tripId,
        userId,
        session,
      );
      this.access.requireRole(actor, ['owner', 'admin']);
      this.access.assertWritable(trip);

      const target = await this.memberModel
        .findOne({ _id: memberId, tripId })
        .session(session)
        .exec();
      if (!target) throw AppError.notFound('TRIP_NOT_FOUND', 'Member not found');

      if (target.role === 'owner' && actor.role !== 'owner') {
        throw AppError.forbidden();
      }

      if (dto.displayName !== undefined) target.displayName = dto.displayName.trim();

      if (dto.email !== undefined) {
        const email = assertEmail(dto.email);
        const duplicate = await this.memberModel
          .findOne(
            { tripId, emailNormalized: email, _id: { $ne: target._id } },
            null,
            { session },
          )
          .lean()
          .exec();
        if (duplicate) {
          throw AppError.conflict(
            'EMAIL_IN_USE',
            'A member with this email already exists in the trip',
          );
        }
        target.emailNormalized = email;
      }

      await target.save({ session });

      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'member.updated',
        entityType: 'member',
        entityId: target._id,
        actorUserId: userId,
        payload: memberSnapshot(target),
      });

      return { status: 200, body: memberSnapshot(target) };
    });
  }

  async changeRole(
    tripId: string,
    userId: string,
    memberId: string,
    dto: ChangeRoleDto,
    idempotencyKey?: string,
  ) {
    const requestHash = hashRequest(
      'PATCH',
      `/v1/trips/${tripId}/members/${memberId}/role`,
      dto,
    );
    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const { member: actor } = await this.access.requireMembership(tripId, userId, session);
      this.access.requireRole(actor, ['owner']);

      const target = await this.memberModel
        .findOne({ _id: memberId, tripId, status: 'active' })
        .session(session)
        .exec();
      if (!target) throw AppError.notFound('TRIP_NOT_FOUND', 'Member not found');
      if (target.role === 'owner' || target.memberKind !== 'account') {
        throw AppError.conflict('MEMBER_NOT_ELIGIBLE', 'This member cannot be assigned a role');
      }

      target.role = dto.role;
      await target.save({ session });

      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'member.updated',
        entityType: 'member',
        entityId: target._id,
        actorUserId: userId,
        payload: memberSnapshot(target),
      });

      if (target.userId) {
        await this.events.appendUserEvent(session, {
          userId: target.userId,
          eventType: 'trip.membership.changed',
          tripId,
          payload: { tripId, memberId: target._id, role: target.role },
        });
      }

      return { status: 200, body: memberSnapshot(target) };
    });
  }

  async remove(
    tripId: string,
    userId: string,
    memberId: string,
    idempotencyKey?: string,
  ) {
    const requestHash = hashRequest(
      'POST',
      `/v1/trips/${tripId}/members/${memberId}/remove`,
      {},
    );
    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const { trip, member: actor } = await this.access.requireMembership(
        tripId,
        userId,
        session,
      );
      this.access.requireRole(actor, ['owner', 'admin']);
      this.access.assertWritable(trip);

      const target = await this.memberModel
        .findOne({ _id: memberId, tripId, status: 'active' })
        .session(session)
        .exec();
      if (!target) throw AppError.notFound('TRIP_NOT_FOUND', 'Member not found');
      if (target.role === 'owner') {
        throw AppError.conflict('MEMBER_NOT_ELIGIBLE', 'Transfer ownership before removing the owner');
      }
      if (target.role === 'admin' && actor.role !== 'owner') {
        throw AppError.forbidden();
      }

      target.status = 'removed';
      await target.save({ session });

      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'member.removed',
        entityType: 'member',
        entityId: target._id,
        actorUserId: userId,
        payload: memberSnapshot(target),
      });

      if (target.userId) {
        await this.events.appendUserEvent(session, {
          userId: target.userId,
          eventType: 'trip.access.revoked',
          tripId,
          payload: { tripId, memberId: target._id, reason: 'removed' },
        });
      }

      return { status: 200, body: { removed: true, memberId: target._id } };
    });
  }

  async claim(tripId: string, userId: string, memberId: string, idempotencyKey?: string) {
    const requestHash = hashRequest(
      'POST',
      `/v1/trips/${tripId}/members/${memberId}/claim`,
      {},
    );
    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const user = await this.userModel.findById(userId).session(session).exec();
      if (!user) {
        throw AppError.notFound('TRIP_NOT_FOUND', 'Account not found');
      }

      const member = await this.memberModel
        .findOne({ _id: memberId, tripId, status: 'active' })
        .session(session)
        .exec();
      if (!member) throw AppError.notFound('TRIP_NOT_FOUND', 'Member not found');
      if (member.memberKind !== 'guest' || !member.emailNormalized) {
        throw AppError.conflict(
          'MEMBER_NOT_ELIGIBLE',
          'An owner or admin must attach an email before this membership can be claimed',
        );
      }
      if (normalizeEmail(user.emailNormalized) !== member.emailNormalized) {
        throw AppError.forbidden();
      }

      const existing = await this.memberModel
        .findOne({ tripId, userId, _id: { $ne: member._id } }, null, { session })
        .lean()
        .exec();
      if (existing) {
        throw AppError.conflict(
          'MEMBER_NOT_ELIGIBLE',
          'You already have a membership record in this trip',
        );
      }

      member.userId = userId;
      member.memberKind = 'account';
      member.status = 'active';
      member.joinedAt = new Date();
      await member.save({ session });

      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'member.updated',
        entityType: 'member',
        entityId: member._id,
        actorUserId: userId,
        payload: memberSnapshot(member),
      });
      await this.events.appendUserEvent(session, {
        userId,
        eventType: 'trip.access.granted',
        tripId,
        payload: { tripId, memberId: member._id, role: member.role },
      });

      return { status: 200, body: memberSnapshot(member) };
    });
  }
}
