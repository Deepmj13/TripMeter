import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { randomUUID } from 'crypto';
import { AppError } from '../common/errors/app-error';
import { EventWriterService } from '../common/services/event-writer.service';
import { IdempotencyService } from '../common/services/idempotency.service';
import { hashRequest } from '../common/utils/canonical-json';
import {
  assertCalendarDate,
  assertUuid,
  isUuid,
} from '../common/utils/validation';
import { MAX_PAGE_SIZE, SUPPORTED_CURRENCIES } from '../common/constants';
import { memberSnapshot, tripSnapshot } from '../common/serializers';
import { Expense, ExpenseDocument } from '../database/schemas/expense.schema';
import { Trip, TripDocument } from '../database/schemas/trip.schema';
import { TripEvent, TripEventDocument } from '../database/schemas/trip-event.schema';
import { TripMember, TripMemberDocument } from '../database/schemas/trip-member.schema';
import { User, UserDocument } from '../database/schemas/user.schema';
import {
  CreateTripDto,
  LeaveTripDto,
  TransferOwnershipDto,
  UpdateTripDto,
} from './dto/trips.dto';
import { TripAccessService } from './trip-access.service';

@Injectable()
export class TripsService {
  constructor(
    @InjectModel(Trip.name) private readonly tripModel: Model<TripDocument>,
    @InjectModel(TripMember.name) private readonly memberModel: Model<TripMemberDocument>,
    @InjectModel(Expense.name) private readonly expenseModel: Model<ExpenseDocument>,
    @InjectModel(TripEvent.name) private readonly eventModel: Model<TripEventDocument>,
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
    private readonly access: TripAccessService,
    private readonly events: EventWriterService,
    private readonly idempotency: IdempotencyService,
  ) {}

  async create(userId: string, dto: CreateTripDto, idempotencyKey?: string) {
    const requestHash = hashRequest('POST', '/v1/trips', dto);
    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const user = await this.userModel.findById(userId).session(session).exec();
      if (!user) throw AppError.notFound('TRIP_NOT_FOUND', 'Account not found');

      const tripId = dto.id ? assertUuid(dto.id, 'id') : randomUUID();
      const existing = await this.tripModel
        .findOne({ _id: tripId }, null, { session })
        .lean()
        .exec();
      if (existing) {
        throw AppError.conflict('ENTITY_ID_CONFLICT', 'A trip with this ID already exists');
      }

      const currency = dto.currency ?? 'INR';
      const currencyExponent = SUPPORTED_CURRENCIES[currency];
      if (currencyExponent === undefined) {
        throw AppError.validation('Unsupported currency');
      }

      this.validateDates(dto.startDate, dto.endDate);

      const trip = (
        await this.tripModel.create(
          [
            {
              _id: tripId,
              name: dto.name.trim(),
              destination: dto.destination?.trim() ?? '',
              description: dto.description?.trim() ?? '',
              currency,
              currencyExponent,
              startDate: dto.startDate ?? null,
              endDate: dto.endDate ?? null,
              createdByUserId: userId,
              ownerUserId: userId,
              syncVersion: 0,
              archivedAt: null,
            },
          ],
          { session },
        )
      )[0];

      const member = (
        await this.memberModel.create(
          [
            {
              _id: randomUUID(),
              tripId,
              userId,
              displayName: user.name,
              emailNormalized: user.emailNormalized,
              memberKind: 'account',
              role: 'owner',
              status: 'active',
              createdByUserId: userId,
              joinedAt: new Date(),
            },
          ],
          { session },
        )
      )[0];

      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'trip.created',
        entityType: 'trip',
        entityId: tripId,
        actorUserId: userId,
        payload: tripSnapshot(trip),
      });

      await this.events.appendUserEvent(session, {
        userId,
        eventType: 'trip.access.granted',
        tripId,
        payload: { tripId, memberId: member._id, role: 'owner' },
      });

      return {
        status: 201,
        body: {
          trip: tripSnapshot(trip),
          membership: memberSnapshot(member),
          myRole: 'owner',
        },
      };
    });
  }

  async list(userId: string) {
    const memberships = await this.memberModel
      .find({ userId, status: 'active' })
      .lean()
      .exec();
    if (memberships.length === 0) return { items: [] };

    const trips = await this.tripModel
      .find({ _id: { $in: memberships.map((membership) => membership.tripId) } })
      .sort({ updatedAt: -1 })
      .lean()
      .exec();

    const roleByTrip = new Map(memberships.map((m) => [m.tripId, m]));
    return {
      items: trips.map((trip) => {
        const membership = roleByTrip.get(trip._id);
        return {
          ...tripSnapshot(trip as unknown as TripDocument),
          myRole: membership?.role ?? 'member',
          memberId: membership?._id ?? null,
        };
      }),
    };
  }

  async get(tripId: string, userId: string) {
    const { trip, member } = await this.access.requireMembership(tripId, userId);
    return {
      trip: tripSnapshot(trip),
      membership: memberSnapshot(member),
      myRole: member.role,
    };
  }

  async update(
    tripId: string,
    userId: string,
    dto: UpdateTripDto,
    idempotencyKey?: string,
  ) {
    const requestHash = hashRequest('PATCH', `/v1/trips/${tripId}`, dto);
    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const { trip, member } = await this.access.requireMembership(tripId, userId, session);
      this.access.requireRole(member, ['owner', 'admin']);
      this.access.assertWritable(trip);

      const set: Record<string, unknown> = {};
      if (dto.name !== undefined) set.name = dto.name.trim();
      if (dto.destination !== undefined) set.destination = dto.destination.trim();
      if (dto.description !== undefined) set.description = dto.description.trim();
      if (dto.startDate !== undefined) set.startDate = assertCalendarDate(dto.startDate, 'startDate');
      if (dto.endDate !== undefined) set.endDate = assertCalendarDate(dto.endDate, 'endDate');

      if (dto.currency !== undefined && dto.currency !== trip.currency) {
        const hasExpense = await this.expenseModel
          .exists({ tripId })
          .session(session)
          .exec();
        if (hasExpense) {
          throw AppError.conflict(
            'CURRENCY_IMMUTABLE',
            'The trip currency cannot change after an expense has been recorded',
          );
        }
        const exponent = SUPPORTED_CURRENCIES[dto.currency];
        if (exponent === undefined) throw AppError.validation('Unsupported currency');
        set.currency = dto.currency;
        set.currencyExponent = exponent;
      }

      const start = (set.startDate as string | undefined) ?? trip.startDate;
      const end = (set.endDate as string | undefined) ?? trip.endDate;
      this.validateDates(start ?? undefined, end ?? undefined);

      const updated = await this.tripModel
        .findOneAndUpdate({ _id: tripId }, { $set: set }, { new: true, session })
        .exec();
      if (!updated) throw AppError.notFound('TRIP_NOT_FOUND', 'Trip not found');

      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'trip.updated',
        entityType: 'trip',
        entityId: tripId,
        actorUserId: userId,
        payload: tripSnapshot(updated),
      });

      return { status: 200, body: { trip: tripSnapshot(updated), myRole: member.role } };
    });
  }

  async archive(tripId: string, userId: string, idempotencyKey?: string) {
    return this.setArchived(tripId, userId, true, idempotencyKey);
  }

  async unarchive(tripId: string, userId: string, idempotencyKey?: string) {
    return this.setArchived(tripId, userId, false, idempotencyKey);
  }

  private async setArchived(
    tripId: string,
    userId: string,
    archived: boolean,
    idempotencyKey?: string,
  ) {
    const action = archived ? 'archive' : 'unarchive';
    const requestHash = hashRequest('POST', `/v1/trips/${tripId}/${action}`, {});
    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const { member } = await this.access.requireMembership(tripId, userId, session);
      this.access.requireRole(member, ['owner']);

      const updated = await this.tripModel
        .findOneAndUpdate(
          { _id: tripId },
          { $set: { archivedAt: archived ? new Date() : null } },
          { new: true, session },
        )
        .exec();
      if (!updated) throw AppError.notFound('TRIP_NOT_FOUND', 'Trip not found');

      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'trip.updated',
        entityType: 'trip',
        entityId: tripId,
        actorUserId: userId,
        payload: tripSnapshot(updated),
      });

      return { status: 200, body: { trip: tripSnapshot(updated) } };
    });
  }

  async transferOwnership(
    tripId: string,
    userId: string,
    dto: TransferOwnershipDto,
    idempotencyKey?: string,
  ) {
    const requestHash = hashRequest('POST', `/v1/trips/${tripId}/transfer-ownership`, dto);
    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const { member } = await this.access.requireMembership(tripId, userId, session);
      this.access.requireRole(member, ['owner']);

      const targetId = assertUuid(dto.memberId, 'memberId');
      const target = await this.memberModel
        .findOne({ _id: targetId, tripId, status: 'active' })
        .session(session)
        .exec();

      if (!target || target.memberKind !== 'account' || !target.userId) {
        throw AppError.conflict(
          'MEMBER_NOT_ELIGIBLE',
          'Ownership can only be transferred to an active account member',
        );
      }
      if (target._id === member._id) {
        throw AppError.validation('You already own this trip');
      }

      await this.tripModel.updateOne(
        { _id: tripId },
        { $set: { ownerUserId: target.userId } },
        { session },
      );
      member.role = 'admin';
      await member.save({ session });
      target.role = 'owner';
      await target.save({ session });

      const updated = await this.tripModel.findById(tripId).session(session).exec();
      if (!updated) throw AppError.notFound('TRIP_NOT_FOUND', 'Trip not found');

      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'trip.updated',
        entityType: 'trip',
        entityId: tripId,
        actorUserId: userId,
        payload: tripSnapshot(updated),
      });
      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'member.updated',
        entityType: 'member',
        entityId: member._id,
        actorUserId: userId,
        payload: memberSnapshot(member),
      });
      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'member.updated',
        entityType: 'member',
        entityId: target._id,
        actorUserId: userId,
        payload: memberSnapshot(target),
      });

      await this.events.appendUserEvent(session, {
        userId: target.userId!,
        eventType: 'trip.membership.changed',
        tripId,
        payload: { tripId, memberId: target._id, role: 'owner' },
      });

      return {
        status: 200,
        body: {
          trip: tripSnapshot(updated),
          ownerMemberId: target._id,
          previousOwnerMemberId: member._id,
        },
      };
    });
  }

  async leave(tripId: string, userId: string, dto: LeaveTripDto, idempotencyKey?: string) {
    const requestHash = hashRequest('POST', `/v1/trips/${tripId}/leave`, dto);
    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const { member } = await this.access.requireMembership(tripId, userId, session);
      if (member.role === 'owner') {
        throw AppError.conflict(
          'MEMBER_NOT_ELIGIBLE',
          'The owner must transfer ownership before leaving the trip',
        );
      }

      member.status = 'left';
      await member.save({ session });

      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'member.removed',
        entityType: 'member',
        entityId: member._id,
        actorUserId: userId,
        payload: memberSnapshot(member),
      });
      await this.events.appendUserEvent(session, {
        userId,
        eventType: 'trip.access.revoked',
        tripId,
        payload: { tripId, memberId: member._id, reason: 'left' },
      });

      return { status: 200, body: { left: true, memberId: member._id } };
    });
  }

  async summary(tripId: string, userId: string) {
    const { trip, member } = await this.access.requireMembership(tripId, userId);
    const expenses = await this.expenseModel
      .find({ tripId, status: 'active' })
      .lean()
      .exec();

    const totalMinor = expenses.reduce((sum, expense) => sum + expense.amountMinor, 0);
    const byCategory = new Map<string, number>();
    const paidByMember = new Map<string, number>();
    for (const expense of expenses) {
      byCategory.set(
        expense.category,
        (byCategory.get(expense.category) ?? 0) + expense.amountMinor,
      );
      paidByMember.set(
        expense.paidByMemberId,
        (paidByMember.get(expense.paidByMemberId) ?? 0) + expense.amountMinor,
      );
    }

    const memberCount = await this.memberModel
      .countDocuments({ tripId, status: 'active' })
      .exec();

    const recent = [...expenses]
      .sort((a, b) => {
        if (a.expenseDate !== b.expenseDate) return a.expenseDate < b.expenseDate ? 1 : -1;
        return a._id < b._id ? 1 : -1;
      })
      .slice(0, 5)
      .map((expense) => ({
        id: expense._id,
        title: expense.title,
        amountMinor: expense.amountMinor,
        category: expense.category,
        expenseDate: expense.expenseDate,
        paidByMemberId: expense.paidByMemberId,
      }));

    return {
      tripId,
      myRole: member.role,
      currency: trip.currency,
      currencyExponent: trip.currencyExponent,
      totalMinor,
      expenseCount: expenses.length,
      memberCount,
      byCategory: [...byCategory.entries()].map(([category, amountMinor]) => ({
        category,
        amountMinor,
      })),
      paidByMember: [...paidByMember.entries()].map(([memberId, amountMinor]) => ({
        memberId,
        amountMinor,
      })),
      recentExpenses: recent,
    };
  }

  async audit(tripId: string, userId: string, after = 0, limit = 50) {
    const { member } = await this.access.requireMembership(tripId, userId);
    this.access.requireRole(member, ['owner', 'admin']);

    const safeLimit = Math.min(Math.max(limit, 1), MAX_PAGE_SIZE);
    const events = await this.eventModel
      .find({ tripId, sequence: { $gt: after } })
      .sort({ sequence: 1 })
      .limit(safeLimit + 1)
      .lean()
      .exec();

    const hasMore = events.length > safeLimit;
    const page = hasMore ? events.slice(0, safeLimit) : events;
    return {
      items: page.map((event) => ({
        sequence: event.sequence,
        eventType: event.eventType,
        entityType: event.entityType,
        entityId: event.entityId,
        actorUserId: event.actorUserId,
        payload: event.payload,
        createdAt: (event as unknown as { createdAt?: Date }).createdAt,
      })),
      page: {
        nextCursor: hasMore ? String(page[page.length - 1].sequence) : null,
        hasMore,
      },
    };
  }

  private validateDates(startDate?: string, endDate?: string): void {
    if (startDate) assertCalendarDate(startDate, 'startDate');
    if (endDate) assertCalendarDate(endDate, 'endDate');
    if (startDate && endDate && startDate > endDate) {
      throw AppError.validation('startDate must not be after endDate');
    }
  }

  isUuid(value: unknown): boolean {
    return isUuid(value);
  }
}
