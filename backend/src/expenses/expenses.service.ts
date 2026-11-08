import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { ClientSession, Model } from 'mongoose';
import { randomUUID } from 'crypto';
import { AppError } from '../common/errors/app-error';
import { EventWriterService } from '../common/services/event-writer.service';
import { IdempotencyService } from '../common/services/idempotency.service';
import { hashRequest } from '../common/utils/canonical-json';
import {
  MAX_EXPENSE_PARTICIPANTS,
  MAX_PAGE_SIZE,
} from '../common/constants';
import {
  allocateEqualSplit,
  assertAmountMinor,
  assertNonNegativeMinor,
  SplitAllocation,
} from '../common/utils/money';
import {
  assertCalendarDate,
  assertUuid,
} from '../common/utils/validation';
import { decodeCursor, encodeCursor } from '../common/utils/cursor';
import { expenseSnapshot } from '../common/serializers';
import { Expense, ExpenseDocument } from '../database/schemas/expense.schema';
import { TripMember, TripMemberDocument } from '../database/schemas/trip-member.schema';
import {
  CreateExpenseDto,
  ListExpensesQueryDto,
  UpdateExpenseDto,
} from './dto/expenses.dto';
import { TripAccessService } from '../trips/trip-access.service';

@Injectable()
export class ExpensesService {
  constructor(
    @InjectModel(Expense.name) private readonly expenseModel: Model<ExpenseDocument>,
    @InjectModel(TripMember.name) private readonly memberModel: Model<TripMemberDocument>,
    private readonly access: TripAccessService,
    private readonly events: EventWriterService,
    private readonly idempotency: IdempotencyService,
  ) {}

  async create(
    tripId: string,
    userId: string,
    dto: CreateExpenseDto,
    idempotencyKey?: string,
  ) {
    const requestHash = hashRequest('POST', `/v1/trips/${tripId}/expenses`, dto);
    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const { trip } = await this.access.requireMembership(
        tripId,
        userId,
        session,
      );
      this.access.assertWritable(trip);

      const amountMinor = assertAmountMinor(dto.amountMinor);
      const expenseDate = assertCalendarDate(dto.expenseDate, 'expenseDate');
      const expenseId = dto.id ? assertUuid(dto.id, 'id') : randomUUID();

      const duplicate = await this.expenseModel
        .findOne({ _id: expenseId }, null, { session })
        .lean()
        .exec();
      if (duplicate) {
        throw AppError.conflict('ENTITY_ID_CONFLICT', 'An expense with this ID already exists');
      }

      const payer = await this.requireActiveMember(tripId, dto.paidByMemberId, session);
      const splits = await this.resolveSplits(
        tripId,
        dto.splitType,
        amountMinor,
        dto.participantMemberIds,
        dto.splits,
        session,
      );

      const expense = (
        await this.expenseModel.create(
          [
            {
              _id: expenseId,
              tripId,
              title: dto.title.trim(),
              amountMinor,
              currency: trip.currency,
              paidByMemberId: payer._id,
              createdByUserId: userId,
              updatedByUserId: null,
              deletedByUserId: null,
              splitType: dto.splitType,
              splits,
              category: dto.category ?? 'other',
              expenseDate,
              description: dto.description?.trim() ?? '',
              status: 'active',
              version: 1,
              clientCreatedAt: dto.clientCreatedAt ? new Date(dto.clientCreatedAt) : new Date(),
              deletedAt: null,
            },
          ],
          { session },
        )
      )[0];

      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'expense.created',
        entityType: 'expense',
        entityId: expense._id,
        actorUserId: userId,
        payload: expenseSnapshot(expense),
      });

      await this.notifyTripMembers(
        session,
        tripId,
        userId,
        'expense.created',
        expense._id,
        `New expense: ${expense.title}`,
      );

      return { status: 201, body: expenseSnapshot(expense) };
    });
  }

  async update(
    tripId: string,
    expenseId: string,
    userId: string,
    dto: UpdateExpenseDto,
    ifMatch: string | undefined,
    idempotencyKey?: string,
  ) {
    const expectedVersion = this.parseIfMatch(ifMatch);
    const requestHash = hashRequest(
      'PATCH',
      `/v1/trips/${tripId}/expenses/${expenseId}`,
      dto,
    );

    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const { trip, member: actor } = await this.access.requireMembership(
        tripId,
        userId,
        session,
      );
      this.access.assertWritable(trip);

      const existing = await this.expenseModel
        .findOne({ _id: expenseId, tripId, status: 'active' })
        .session(session)
        .exec();
      if (!existing) throw AppError.notFound('TRIP_NOT_FOUND', 'Expense not found');

      if (actor.role !== 'owner' && existing.createdByUserId !== userId) {
        throw AppError.forbidden();
      }

      const amountMinor =
        dto.amountMinor !== undefined
          ? assertAmountMinor(dto.amountMinor)
          : existing.amountMinor;
      const splitType = dto.splitType ?? existing.splitType;
      const payerId = dto.paidByMemberId ?? existing.paidByMemberId;

      const alreadyReferenced = new Set<string>([
        existing.paidByMemberId,
        ...existing.splits.map((split) => split.memberId),
      ]);
      const payer = await this.requireMemberForUpdate(
        tripId,
        payerId,
        alreadyReferenced,
        session,
      );

      let splits: SplitAllocation[];
      if (splitType === 'equal') {
        const participantIds =
          dto.participantMemberIds ??
          (dto.splitType === 'custom' ? null : existing.splits.map((split) => split.memberId));
        if (!participantIds) {
          throw AppError.validation(
            'participantMemberIds is required when changing to an equal split',
          );
        }
        splits = allocateEqualSplit(amountMinor, participantIds, MAX_EXPENSE_PARTICIPANTS);
        await this.validateEligibility(
          tripId,
          splits.map((split) => split.memberId),
          alreadyReferenced,
          session,
        );
      } else {
        if (!dto.splits && amountMinor !== existing.amountMinor) {
          throw AppError.validation(
            'splits is required when changing the amount of a custom-split expense',
          );
        }
        const customSplits = dto.splits
          ? this.validateCustomSplits(amountMinor, dto.splits)
          : existing.splits.map((split) => ({
              memberId: split.memberId,
              amountMinor: split.amountMinor,
            }));
        await this.validateEligibility(
          tripId,
          customSplits.map((split) => split.memberId),
          alreadyReferenced,
          session,
        );
        splits = customSplits;
      }

      if (dto.expenseDate) assertCalendarDate(dto.expenseDate, 'expenseDate');

      const set: Record<string, unknown> = {
        amountMinor,
        paidByMemberId: payer._id,
        splitType,
        splits,
        updatedByUserId: userId,
      };
      if (dto.title !== undefined) set.title = dto.title.trim();
      if (dto.expenseDate !== undefined) set.expenseDate = dto.expenseDate;
      if (dto.category !== undefined) set.category = dto.category;
      if (dto.description !== undefined) set.description = dto.description.trim();

      const updated = await this.expenseModel
        .findOneAndUpdate(
          {
            _id: expenseId,
            tripId,
            status: 'active',
            version: expectedVersion,
          },
          { $set: set, $inc: { version: 1 } },
          { new: true, session },
        )
        .exec();

      if (!updated) {
        const current = await this.expenseModel
          .findOne({ _id: expenseId, tripId }, null, { session })
          .lean()
          .exec();
        if (!current) throw AppError.notFound('TRIP_NOT_FOUND', 'Expense not found');
        throw AppError.conflict(
          'EXPENSE_VERSION_CONFLICT',
          'The expense was changed by another device',
          {
            currentVersion: current.version,
            refetchUrl: `/v1/trips/${tripId}/expenses/${expenseId}`,
          },
        );
      }

      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'expense.updated',
        entityType: 'expense',
        entityId: updated._id,
        actorUserId: userId,
        payload: expenseSnapshot(updated),
      });

      await this.notifyTripMembers(
        session,
        tripId,
        userId,
        'expense.updated',
        updated._id,
        `Expense updated: ${updated.title}`,
      );

      return { status: 200, body: expenseSnapshot(updated) };
    });
  }

  async remove(
    tripId: string,
    expenseId: string,
    userId: string,
    ifMatch: string | undefined,
    idempotencyKey?: string,
  ) {
    const expectedVersion = this.parseIfMatch(ifMatch);
    const requestHash = hashRequest(
      'DELETE',
      `/v1/trips/${tripId}/expenses/${expenseId}`,
      {},
    );

    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const { trip, member: actor } = await this.access.requireMembership(
        tripId,
        userId,
        session,
      );
      this.access.assertWritable(trip);

      const existing = await this.expenseModel
        .findOne({ _id: expenseId, tripId, status: 'active' })
        .session(session)
        .exec();
      if (!existing) throw AppError.notFound('TRIP_NOT_FOUND', 'Expense not found');
      if (actor.role !== 'owner' && existing.createdByUserId !== userId) {
        throw AppError.forbidden();
      }

      const now = new Date();
      const deleted = await this.expenseModel
        .findOneAndUpdate(
          { _id: expenseId, tripId, status: 'active', version: expectedVersion },
          {
            $set: {
              status: 'deleted',
              deletedAt: now,
              deletedByUserId: userId,
              updatedByUserId: userId,
            },
            $inc: { version: 1 },
          },
          { new: true, session },
        )
        .exec();

      if (!deleted) {
        const current = await this.expenseModel
          .findOne({ _id: expenseId, tripId }, null, { session })
          .lean()
          .exec();
        if (!current) throw AppError.notFound('TRIP_NOT_FOUND', 'Expense not found');
        throw AppError.conflict(
          'EXPENSE_VERSION_CONFLICT',
          'The expense was changed by another device',
          {
            currentVersion: current.version,
            refetchUrl: `/v1/trips/${tripId}/expenses/${expenseId}`,
          },
        );
      }

      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'expense.deleted',
        entityType: 'expense',
        entityId: deleted._id,
        actorUserId: userId,
        payload: expenseSnapshot(deleted),
      });

      return { status: 200, body: expenseSnapshot(deleted) };
    });
  }

  async list(tripId: string, userId: string, query: ListExpensesQueryDto) {
    const { member } = await this.access.requireMembership(tripId, userId);
    const limit = Math.min(Math.max(Number(query.limit) || 50, 1), MAX_PAGE_SIZE);

    const filter: Record<string, unknown> = { tripId };
    if (query.status && (member.role === 'owner' || member.role === 'admin')) {
      filter.status = query.status;
    } else {
      filter.status = 'active';
    }
    if (query.category) filter.category = query.category;
    if (query.fromDate) filter.expenseDate = { $gte: assertCalendarDate(query.fromDate, 'fromDate') };
    if (query.toDate) {
      filter.expenseDate = {
        ...(filter.expenseDate as object | undefined),
        $lte: assertCalendarDate(query.toDate, 'toDate'),
      };
    }
    if (query.memberId) {
      filter.$or = [
        { paidByMemberId: query.memberId },
        { 'splits.memberId': query.memberId },
      ];
    }
    if (query.cursor) {
      const cursor = decodeCursor(query.cursor);
      const cursorFilter = {
        $or: [
          { expenseDate: { $lt: cursor.value } },
          { expenseDate: cursor.value, _id: { $lt: cursor.id } },
        ],
      };
      filter.$and = [cursorFilter];
    }

    const expenses = await this.expenseModel
      .find(filter)
      .sort({ expenseDate: -1, _id: -1 })
      .limit(limit + 1)
      .exec();

    const hasMore = expenses.length > limit;
    const page = hasMore ? expenses.slice(0, limit) : expenses;
    const last = page[page.length - 1];

    return {
      items: page.map(expenseSnapshot),
      page: {
        nextCursor:
          hasMore && last ? encodeCursor({ value: last.expenseDate, id: last._id }) : null,
        hasMore,
      },
    };
  }

  async get(tripId: string, expenseId: string, userId: string) {
    await this.access.requireMembership(tripId, userId);
    const expense = await this.expenseModel.findOne({ _id: expenseId, tripId }).exec();
    if (!expense) throw AppError.notFound('TRIP_NOT_FOUND', 'Expense not found');
    return expenseSnapshot(expense);
  }

  private async resolveSplits(
    tripId: string,
    splitType: 'equal' | 'custom',
    amountMinor: number,
    participantIds: string[] | undefined,
    customSplits: { memberId: string; amountMinor: number }[] | undefined,
    session: ClientSession,
  ): Promise<SplitAllocation[]> {
    if (splitType === 'equal') {
      if (!participantIds || participantIds.length === 0) {
        throw AppError.validation('participantMemberIds is required for an equal split');
      }
      const splits = allocateEqualSplit(
        amountMinor,
        participantIds,
        MAX_EXPENSE_PARTICIPANTS,
      );
      await this.validateEligibility(
        tripId,
        splits.map((split) => split.memberId),
        new Set(),
        session,
      );
      return splits;
    }

    if (!customSplits) {
      throw AppError.validation('splits is required for a custom split');
    }
    const splits = this.validateCustomSplits(amountMinor, customSplits);
    await this.validateEligibility(
      tripId,
      splits.map((split) => split.memberId),
      new Set(),
      session,
    );
    return splits;
  }

  private validateCustomSplits(
    amountMinor: number,
    splits: { memberId: string; amountMinor: number }[],
  ): SplitAllocation[] {
    if (!Array.isArray(splits) || splits.length === 0) {
      throw AppError.validation('At least one split participant is required');
    }
    if (splits.length > MAX_EXPENSE_PARTICIPANTS) {
      throw AppError.validation(
        `An expense may have at most ${MAX_EXPENSE_PARTICIPANTS} participants`,
      );
    }
    const seen = new Set<string>();
    let total = 0;
    for (const split of splits) {
      assertUuid(split.memberId, 'memberId');
      if (seen.has(split.memberId)) {
        throw AppError.validation('Duplicate split participants are not allowed');
      }
      seen.add(split.memberId);
      total += assertNonNegativeMinor(split.amountMinor, 'splits.amountMinor');
    }
    if (total !== amountMinor) {
      throw AppError.conflict(
        'EXPENSE_SPLIT_MISMATCH',
        'The split amounts must add up to the expense amount',
        { expected: amountMinor, actual: total },
      );
    }
    return splits.map((split) => ({
      memberId: split.memberId,
      amountMinor: split.amountMinor,
    }));
  }

  private async validateEligibility(
    tripId: string,
    memberIds: string[],
    alreadyReferenced: Set<string>,
    session: ClientSession,
  ): Promise<void> {
    const members = await this.memberModel
      .find({ _id: { $in: memberIds }, tripId })
      .session(session)
      .exec();
    const byId = new Map(members.map((member) => [member._id, member]));

    for (const memberId of memberIds) {
      const member = byId.get(memberId);
      if (!member) {
        throw AppError.validation('A split participant does not belong to this trip');
      }
      const isNew = !alreadyReferenced.has(memberId);
      if (isNew && member.status !== 'active') {
        throw AppError.conflict(
          'MEMBER_NOT_ELIGIBLE',
          'Only active members can be added to a new expense',
        );
      }
    }
  }

  private async requireActiveMember(
    tripId: string,
    memberId: string,
    session: ClientSession,
  ) {
    assertUuid(memberId, 'memberId');
    const member = await this.memberModel
      .findOne({ _id: memberId, tripId })
      .session(session)
      .exec();
    if (!member) {
      throw AppError.validation('The payer does not belong to this trip');
    }
    if (member.status !== 'active') {
      throw AppError.conflict('MEMBER_NOT_ELIGIBLE', 'The payer must be an active member');
    }
    return member;
  }

  private async requireMemberForUpdate(
    tripId: string,
    memberId: string,
    alreadyReferenced: Set<string>,
    session: ClientSession,
  ) {
    assertUuid(memberId, 'memberId');
    const member = await this.memberModel
      .findOne({ _id: memberId, tripId })
      .session(session)
      .exec();
    if (!member) {
      throw AppError.validation('The payer does not belong to this trip');
    }
    if (member.status !== 'active' && !alreadyReferenced.has(memberId)) {
      throw AppError.conflict('MEMBER_NOT_ELIGIBLE', 'The payer must be an active member');
    }
    return member;
  }

  private parseIfMatch(ifMatch: string | undefined): number {
    if (!ifMatch) {
      throw new AppError(
        'PRECONDITION_REQUIRED',
        'The If-Match header with the current version is required',
        428,
      );
    }
    const normalized = ifMatch.replace(/^W\//, '').replace(/"/g, '').trim();
    const version = Number(normalized);
    if (!Number.isSafeInteger(version) || version < 1) {
      throw AppError.validation('If-Match must contain the entity version');
    }
    return version;
  }

  private async notifyTripMembers(
    session: ClientSession,
    tripId: string,
    actorUserId: string,
    template: string,
    expenseId: string,
    title: string,
  ): Promise<void> {
    const recipients = await this.memberModel
      .find({ tripId, status: 'active', userId: { $nin: [null, actorUserId] } })
      .session(session)
      .lean()
      .exec();

    for (const recipient of recipients) {
      if (!recipient.userId) continue;
      const devices = await this.memberModel.db
        .collection('deviceTokens')
        .find({ userId: recipient.userId, revokedAt: null })
        .project({ deviceId: 1 })
        .toArray();
      await this.events.queuePush(session, {
        recipientUserId: recipient.userId,
        recipientDeviceIds: devices.map((device) => device.deviceId as string),
        template,
        payload: { tripId, expenseId, title },
        dedupeKey: `${template}:${expenseId}:${recipient.userId}`,
      });
    }
  }
}
