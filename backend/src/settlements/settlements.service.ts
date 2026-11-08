import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { ClientSession, Model } from 'mongoose';
import { randomUUID } from 'crypto';
import { AppError } from '../common/errors/app-error';
import { EventWriterService } from '../common/services/event-writer.service';
import { IdempotencyService } from '../common/services/idempotency.service';
import { hashRequest } from '../common/utils/canonical-json';
import { MAX_PAGE_SIZE } from '../common/constants';
import { assertAmountMinor } from '../common/utils/money';
import { assertCalendarDate, assertUuid } from '../common/utils/validation';
import { decodeCursor, encodeCursor } from '../common/utils/cursor';
import { settlementSnapshot } from '../common/serializers';
import { Settlement, SettlementDocument } from '../database/schemas/settlement.schema';
import { TripMember, TripMemberDocument } from '../database/schemas/trip-member.schema';
import {
  CreateSettlementDto,
  ListSettlementsQueryDto,
} from './dto/settlements.dto';
import { TripAccessService } from '../trips/trip-access.service';

@Injectable()
export class SettlementsService {
  private readonly logger = new Logger(SettlementsService.name);

  constructor(
    @InjectModel(Settlement.name)
    private readonly settlementModel: Model<SettlementDocument>,
    @InjectModel(TripMember.name) private readonly memberModel: Model<TripMemberDocument>,
    private readonly access: TripAccessService,
    private readonly events: EventWriterService,
    private readonly idempotency: IdempotencyService,
  ) {}

  async create(
    tripId: string,
    userId: string,
    dto: CreateSettlementDto,
    idempotencyKey?: string,
  ) {
    const requestHash = hashRequest('POST', `/v1/trips/${tripId}/settlements`, dto);
    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const { trip } = await this.access.requireMembership(tripId, userId, session);
      this.access.assertWritable(trip);

      const amountMinor = assertAmountMinor(dto.amountMinor);
      const paymentDate = assertCalendarDate(dto.paymentDate, 'paymentDate');
      const settlementId = dto.id ? assertUuid(dto.id, 'id') : randomUUID();

      if (dto.paidByMemberId === dto.paidToMemberId) {
        throw AppError.validation('The sender and receiver must be different members');
      }

      const sender = await this.requireActiveMember(tripId, dto.paidByMemberId, session);
      const receiver = await this.requireActiveMember(tripId, dto.paidToMemberId, session);

      const duplicate = await this.settlementModel
        .findOne({ _id: settlementId }, null, { session })
        .lean()
        .exec();
      if (duplicate) {
        throw AppError.conflict(
          'ENTITY_ID_CONFLICT',
          'A settlement with this ID already exists',
        );
      }

      const settlement = (
        await this.settlementModel.create(
          [
            {
              _id: settlementId,
              tripId,
              paidByMemberId: sender._id,
              paidToMemberId: receiver._id,
              amountMinor,
              paymentDate,
              status: 'pending',
              recordedByUserId: userId,
              confirmedByUserId: null,
              statusChangedByUserId: null,
              statusChangedAt: null,
              rejectionReason: null,
              note: dto.note?.trim() ?? '',
              version: 1,
              confirmedAt: null,
            },
          ],
          { session },
        )
      )[0];

      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'settlement.created',
        entityType: 'settlement',
        entityId: settlement._id,
        actorUserId: userId,
        payload: settlementSnapshot(settlement),
      });

      await this.notifySettlementReceived(session, tripId, settlement, receiver);

      return { status: 201, body: settlementSnapshot(settlement) };
    });
  }

  async list(tripId: string, userId: string, query: ListSettlementsQueryDto) {
    await this.access.requireMembership(tripId, userId);
    const limit = Math.min(Math.max(Number(query.limit) || 50, 1), MAX_PAGE_SIZE);
    const filter: Record<string, unknown> = { tripId };
    if (query.status) filter.status = query.status;
    if (query.cursor) {
      const cursor = decodeCursor(query.cursor);
      filter.$or = [
        { paymentDate: { $lt: cursor.value } },
        { paymentDate: cursor.value, _id: { $lt: cursor.id } },
      ];
    }

    const settlements = await this.settlementModel
      .find(filter)
      .sort({ paymentDate: -1, _id: -1 })
      .limit(limit + 1)
      .exec();

    const hasMore = settlements.length > limit;
    const page = hasMore ? settlements.slice(0, limit) : settlements;
    const last = page[page.length - 1];

    return {
      items: page.map(settlementSnapshot),
      page: {
        nextCursor:
          hasMore && last
            ? encodeCursor({ value: last.paymentDate, id: last._id })
            : null,
        hasMore,
      },
    };
  }

  async get(tripId: string, settlementId: string, userId: string) {
    await this.access.requireMembership(tripId, userId);
    const settlement = await this.settlementModel
      .findOne({ _id: settlementId, tripId })
      .exec();
    if (!settlement) {
      throw AppError.notFound('TRIP_NOT_FOUND', 'Settlement not found');
    }
    return settlementSnapshot(settlement);
  }

  async confirm(
    tripId: string,
    settlementId: string,
    userId: string,
    ifMatch: string | undefined,
    idempotencyKey?: string,
  ) {
    return this.transition(
      tripId,
      settlementId,
      userId,
      'confirmed',
      ifMatch,
      idempotencyKey,
      undefined,
    );
  }

  async reject(
    tripId: string,
    settlementId: string,
    userId: string,
    ifMatch: string | undefined,
    idempotencyKey?: string,
    reason?: string,
  ) {
    return this.transition(
      tripId,
      settlementId,
      userId,
      'rejected',
      ifMatch,
      idempotencyKey,
      reason,
    );
  }

  async cancel(
    tripId: string,
    settlementId: string,
    userId: string,
    ifMatch: string | undefined,
    idempotencyKey?: string,
  ) {
    return this.transition(
      tripId,
      settlementId,
      userId,
      'cancelled',
      ifMatch,
      idempotencyKey,
      undefined,
    );
  }

  private async transition(
    tripId: string,
    settlementId: string,
    userId: string,
    target: 'confirmed' | 'rejected' | 'cancelled',
    ifMatch: string | undefined,
    idempotencyKey: string | undefined,
    reason: string | undefined,
  ) {
    const expectedVersion = this.parseIfMatch(ifMatch);
    const requestHash = hashRequest(
      'POST',
      `/v1/trips/${tripId}/settlements/${settlementId}/${target === 'confirmed' ? 'confirm' : target === 'rejected' ? 'reject' : 'cancel'}`,
      reason ? { reason } : {},
    );

    return this.idempotency.execute(userId, idempotencyKey, requestHash, async (session) => {
      const { trip, member: actor } = await this.access.requireMembership(
        tripId,
        userId,
        session,
      );
      this.access.assertWritable(trip);

      const settlement = await this.settlementModel
        .findOne({ _id: settlementId, tripId })
        .session(session)
        .exec();
      if (!settlement) {
        throw AppError.notFound('TRIP_NOT_FOUND', 'Settlement not found');
      }

      const receiver = await this.memberModel
        .findOne({ _id: settlement.paidToMemberId, tripId })
        .session(session)
        .exec();
      if (!receiver) {
        throw AppError.notFound('TRIP_NOT_FOUND', 'Receiver not found');
      }

      if (target === 'cancelled') {
        if (settlement.status !== 'pending' && settlement.status !== 'rejected') {
          throw AppError.conflict(
            'SETTLEMENT_INVALID_TRANSITION',
            'Only pending or rejected settlements can be cancelled',
          );
        }
        const isSender = settlement.paidByMemberId === actor._id;
        const isRecorder = settlement.recordedByUserId === userId;
        if (!isSender && !isRecorder) {
          throw AppError.forbidden();
        }
      } else {
        if (settlement.status !== 'pending') {
          throw AppError.conflict(
            'SETTLEMENT_INVALID_TRANSITION',
            'Only pending settlements can be confirmed or rejected',
          );
        }
        this.assertCanRespond(settlement, receiver, actor, userId);
      }

      const now = new Date();
      const set: Record<string, unknown> = {
        status: target,
        version: expectedVersion + 1,
        statusChangedByUserId: userId,
        statusChangedAt: now,
      };
      if (target === 'confirmed') {
        set.confirmedByUserId = userId;
        set.confirmedAt = now;
      }
      if (target === 'rejected') {
        set.rejectionReason = reason?.trim() || null;
      }

      const updated = await this.settlementModel
        .findOneAndUpdate(
          {
            _id: settlementId,
            tripId,
            version: expectedVersion,
            status: settlement.status,
          },
          { $set: set },
          { new: true, session },
        )
        .exec();

      if (!updated) {
        const current = await this.settlementModel
          .findOne({ _id: settlementId, tripId }, null, { session })
          .lean()
          .exec();
        throw AppError.conflict(
          'SETTLEMENT_INVALID_TRANSITION',
          'The settlement changed before this request was applied',
          current ? { currentVersion: current.version, currentStatus: current.status } : undefined,
        );
      }

      await this.events.appendTripEvent(session, {
        tripId,
        eventType: 'settlement.updated',
        entityType: 'settlement',
        entityId: updated._id,
        actorUserId: userId,
        payload: settlementSnapshot(updated),
      });

      return { status: 200, body: settlementSnapshot(updated) };
    });
  }

  private assertCanRespond(
    settlement: SettlementDocument,
    receiver: TripMemberDocument,
    actor: TripMemberDocument,
    userId: string,
  ): void {
    if (receiver.userId && receiver.userId === userId) return;
    if (receiver.memberKind === 'guest' && (actor.role === 'owner' || actor.role === 'admin')) {
      return;
    }
    // An owner or admin must never confirm another registered account member's payment.
    throw AppError.forbidden();
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
      throw AppError.validation('A settlement participant does not belong to this trip');
    }
    if (member.status !== 'active') {
      throw AppError.conflict(
        'MEMBER_NOT_ELIGIBLE',
        'Settlement participants must be active members',
      );
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

  private async notifySettlementReceived(
    session: ClientSession,
    tripId: string,
    settlement: SettlementDocument,
    receiver: TripMemberDocument,
  ): Promise<void> {
    const userId = receiver.userId;
    if (!userId) return;
    try {
      await this.events.queuePush(session, {
        recipientUserId: userId,
        recipientDeviceIds: [],
        template: 'settlement.created',
        payload: {
          tripId,
          settlementId: settlement._id,
          amountMinor: settlement.amountMinor,
        },
        dedupeKey: `settlement.created:${settlement._id}:${userId}`,
      });
    } catch (error) {
      this.logger.warn(
        `Unable to queue settlement notification: ${(error as Error).message}`,
      );
    }
  }
}
