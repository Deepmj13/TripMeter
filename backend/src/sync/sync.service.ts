import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { AppError } from '../common/errors/app-error';
import { SYNC_BATCH_SIZE } from '../common/constants';
import {
  expenseSnapshot,
  memberSnapshot,
  settlementSnapshot,
  tripSnapshot,
} from '../common/serializers';
import { Expense, ExpenseDocument } from '../database/schemas/expense.schema';
import { Settlement, SettlementDocument } from '../database/schemas/settlement.schema';
import { Trip, TripDocument } from '../database/schemas/trip.schema';
import { TripEvent, TripEventDocument } from '../database/schemas/trip-event.schema';
import { TripInvitation, TripInvitationDocument } from '../database/schemas/trip-invitation.schema';
import { TripMember, TripMemberDocument } from '../database/schemas/trip-member.schema';
import { User, UserDocument } from '../database/schemas/user.schema';
import { UserEvent, UserEventDocument } from '../database/schemas/user-event.schema';
import { TripAccessService } from '../trips/trip-access.service';

@Injectable()
export class SyncService {
  constructor(
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
    @InjectModel(UserEvent.name) private readonly userEventModel: Model<UserEventDocument>,
    @InjectModel(Trip.name) private readonly tripModel: Model<TripDocument>,
    @InjectModel(TripMember.name) private readonly memberModel: Model<TripMemberDocument>,
    @InjectModel(TripInvitation.name)
    private readonly invitationModel: Model<TripInvitationDocument>,
    @InjectModel(TripEvent.name) private readonly tripEventModel: Model<TripEventDocument>,
    @InjectModel(Expense.name) private readonly expenseModel: Model<ExpenseDocument>,
    @InjectModel(Settlement.name)
    private readonly settlementModel: Model<SettlementDocument>,
    private readonly access: TripAccessService,
  ) {}

  async userChanges(userId: string, after: number, limit: number) {
    const user = await this.userModel.findById(userId).lean().exec();
    if (!user) throw AppError.notFound('TRIP_NOT_FOUND', 'Account not found');

    const safeLimit = this.limit(limit);
    await this.assertUserCursorValid(userId, after);

    const events = await this.userEventModel
      .find({ userId, sequence: { $gt: after } })
      .sort({ sequence: 1 })
      .limit(safeLimit + 1)
      .lean()
      .exec();

    const hasMore = events.length > safeLimit;
    const page = hasMore ? events.slice(0, safeLimit) : events;
    const nextSequence = page.length > 0 ? page[page.length - 1].sequence : after;

    return {
      changes: page.map((event) => ({
        sequence: event.sequence,
        eventType: event.eventType,
        tripId: event.tripId,
        payload: event.payload,
        createdAt: (event as unknown as { createdAt?: Date }).createdAt,
      })),
      nextSequence,
      hasMore,
      snapshotRequired: false,
    };
  }

  async userSyncStatus(userId: string) {
    const user = await this.userModel.findById(userId).lean().exec();
    if (!user) throw AppError.notFound('TRIP_NOT_FOUND', 'Account not found');
    const retainedFromSequence = await this.minUserSequence(userId);
    return {
      sequence: user.syncVersion,
      retainedFromSequence,
      snapshotRequired: false,
    };
  }

  async userSnapshot(userId: string) {
    const user = await this.userModel.findById(userId).lean().exec();
    if (!user) throw AppError.notFound('TRIP_NOT_FOUND', 'Account not found');

    const memberships = await this.memberModel
      .find({ userId, status: 'active' })
      .lean()
      .exec();
    const trips = await this.tripModel
      .find({ _id: { $in: memberships.map((membership) => membership.tripId) } })
      .lean()
      .exec();
    const roleByTrip = new Map(memberships.map((membership) => [membership.tripId, membership]));
    const invitations = await this.invitationModel
      .find({ emailNormalized: user.emailNormalized, status: 'pending' })
      .lean()
      .exec();

    return {
      profile: {
        id: user._id,
        name: user.name,
        email: user.email,
        notificationPreferences: user.notificationPreferences,
      },
      trips: trips.map((trip) => ({
        ...tripSnapshot(trip as unknown as TripDocument),
        myRole: roleByTrip.get(trip._id)?.role ?? 'member',
        memberId: roleByTrip.get(trip._id)?._id ?? null,
      })),
      invitations: invitations.map((invitation) => ({
        id: invitation._id,
        tripId: invitation.tripId,
        memberId: invitation.memberId,
        status: invitation.status,
        expiresAt: invitation.expiresAt,
      })),
      sequence: user.syncVersion,
    };
  }

  async tripChanges(tripId: string, userId: string, after: number, limit: number) {
    await this.access.requireMembership(tripId, userId);
    const safeLimit = this.limit(limit);
    await this.assertTripCursorValid(tripId, after);

    const events = await this.tripEventModel
      .find({ tripId, sequence: { $gt: after } })
      .sort({ sequence: 1 })
      .limit(safeLimit + 1)
      .lean()
      .exec();

    const hasMore = events.length > safeLimit;
    const page = hasMore ? events.slice(0, safeLimit) : events;
    const nextSequence = page.length > 0 ? page[page.length - 1].sequence : after;

    return {
      changes: page.map((event) => ({
        sequence: event.sequence,
        eventType: event.eventType,
        entityType: event.entityType,
        entityId: event.entityId,
        payload: event.payload,
        createdAt: (event as unknown as { createdAt?: Date }).createdAt,
      })),
      nextSequence,
      hasMore,
      snapshotRequired: false,
    };
  }

  async tripSyncStatus(tripId: string, userId: string) {
    const { trip } = await this.access.requireMembership(tripId, userId);
    const retainedFromSequence = await this.minTripSequence(tripId);
    return {
      sequence: trip.syncVersion,
      retainedFromSequence,
      snapshotRequired: false,
    };
  }

  async tripSnapshot(tripId: string, userId: string) {
    const { trip, member: actor } = await this.access.requireMembership(tripId, userId);

    const [members, expenses, settlements] = await Promise.all([
      this.memberModel.find({ tripId }).lean().exec(),
      this.expenseModel.find({ tripId, status: 'active' }).lean().exec(),
      this.settlementModel.find({ tripId, status: 'confirmed' }).lean().exec(),
    ]);

    const canSeeEmails = actor.role === 'owner' || actor.role === 'admin';

    return {
      sequence: trip.syncVersion,
      trip: tripSnapshot(trip),
      members: members.map((member) => ({
        ...memberSnapshot(member as unknown as TripMemberDocument),
        ...(canSeeEmails || member.userId === userId
          ? { email: member.emailNormalized }
          : {}),
      })),
      expenses: expenses.map((expense) =>
        expenseSnapshot(expense as unknown as ExpenseDocument),
      ),
      settlements: settlements.map((settlement) =>
        settlementSnapshot(settlement as unknown as SettlementDocument),
      ),
    };
  }

  private limit(value: number): number {
    return Math.min(Math.max(Number(value) || SYNC_BATCH_SIZE, 1), SYNC_BATCH_SIZE);
  }

  private async minUserSequence(userId: string): Promise<number> {
    const oldest = await this.userEventModel
      .findOne({ userId })
      .sort({ sequence: 1 })
      .lean()
      .exec();
    if (!oldest) return 1;
    return oldest.sequence;
  }

  private async minTripSequence(tripId: string): Promise<number> {
    const oldest = await this.tripEventModel
      .findOne({ tripId })
      .sort({ sequence: 1 })
      .lean()
      .exec();
    if (!oldest) return 1;
    return oldest.sequence;
  }

  private async assertUserCursorValid(userId: string, after: number): Promise<void> {
    if (after <= 0) return;
    const retainedFrom = await this.minUserSequence(userId);
    if (after < retainedFrom - 1) {
      throw new AppError(
        'CURSOR_EXPIRED',
        'The sync cursor is older than the retained event window',
        410,
        { snapshotUrl: '/v1/users/me/snapshot' },
      );
    }
  }

  private async assertTripCursorValid(tripId: string, after: number): Promise<void> {
    if (after <= 0) return;
    const retainedFrom = await this.minTripSequence(tripId);
    if (after < retainedFrom - 1) {
      throw new AppError(
        'CURSOR_EXPIRED',
        'The sync cursor is older than the retained event window',
        410,
        { snapshotUrl: `/v1/trips/${tripId}/snapshot` },
      );
    }
  }
}
