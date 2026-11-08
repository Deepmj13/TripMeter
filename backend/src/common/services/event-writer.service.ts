import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { ClientSession, Model } from 'mongoose';
import { randomUUID } from 'crypto';
import {
  NotificationOutbox,
  NotificationOutboxDocument,
} from '../../database/schemas/notification-outbox.schema';
import { Trip, TripDocument } from '../../database/schemas/trip.schema';
import { TripEvent, TripEventDocument } from '../../database/schemas/trip-event.schema';
import { User, UserDocument } from '../../database/schemas/user.schema';
import { UserEvent, UserEventDocument } from '../../database/schemas/user-event.schema';
import { AppError } from '../errors/app-error';
import { OUTBOX_MAX_AUTOMATIC_ATTEMPTS } from '../constants';

export interface TripEventInput {
  tripId: string;
  eventType: (typeof import('../constants').EVENT_TYPES)[number];
  entityType: string;
  entityId: string;
  actorUserId: string;
  payload: Record<string, unknown>;
}

export interface UserEventInput {
  userId: string;
  eventType: (typeof import('../constants').USER_EVENT_TYPES)[number];
  tripId?: string | null;
  payload: Record<string, unknown>;
}

@Injectable()
export class EventWriterService {
  constructor(
    @InjectModel(Trip.name) private readonly tripModel: Model<TripDocument>,
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
    @InjectModel(TripEvent.name) private readonly tripEventModel: Model<TripEventDocument>,
    @InjectModel(UserEvent.name) private readonly userEventModel: Model<UserEventDocument>,
    @InjectModel(NotificationOutbox.name)
    private readonly notificationModel: Model<NotificationOutboxDocument>,
  ) {}

  async appendTripEvent(session: ClientSession, input: TripEventInput): Promise<number> {
    const trip = await this.tripModel
      .findOneAndUpdate(
        { _id: input.tripId },
        { $inc: { syncVersion: 1 } },
        { new: true, session, projection: { syncVersion: 1 } },
      )
      .lean()
      .exec();

    if (!trip) throw AppError.notFound('TRIP_NOT_FOUND', 'Trip not found');
    if (!Number.isSafeInteger(trip.syncVersion)) {
      throw AppError.conflict('CURRENCY_IMMUTABLE', 'The trip sequence is exhausted');
    }

    await this.tripEventModel.create(
      [
        {
          _id: randomUUID(),
          tripId: input.tripId,
          sequence: trip.syncVersion,
          eventType: input.eventType,
          entityType: input.entityType,
          entityId: input.entityId,
          actorUserId: input.actorUserId,
          payload: input.payload,
        },
      ],
      { session },
    );

    return trip.syncVersion;
  }

  async appendUserEvent(session: ClientSession, input: UserEventInput): Promise<number> {
    const user = await this.userModel
      .findOneAndUpdate(
        { _id: input.userId },
        { $inc: { syncVersion: 1 } },
        { new: true, session, projection: { syncVersion: 1 } },
      )
      .lean()
      .exec();

    if (!user) return 0;
    if (!Number.isSafeInteger(user.syncVersion)) {
      throw AppError.conflict('CURRENCY_IMMUTABLE', 'The user sequence is exhausted');
    }

    await this.userEventModel.create(
      [
        {
          _id: randomUUID(),
          userId: input.userId,
          sequence: user.syncVersion,
          eventType: input.eventType,
          tripId: input.tripId ?? null,
          payload: input.payload,
        },
      ],
      { session },
    );

    return user.syncVersion;
  }

  async queueEmail(
    session: ClientSession,
    input: {
      recipientUserId?: string | null;
      recipientEmail: string;
      template: string;
      payload: Record<string, unknown>;
      dedupeKey: string;
    },
  ): Promise<void> {
    await this.notificationModel
      .updateOne(
        { dedupeKey: input.dedupeKey },
        {
          $setOnInsert: {
            _id: randomUUID(),
            channel: 'email',
            recipientUserId: input.recipientUserId ?? null,
            recipientEmail: input.recipientEmail,
            recipientDeviceIds: [],
            template: input.template,
            payload: input.payload,
            dedupeKey: input.dedupeKey,
            status: 'pending',
            attemptCount: 0,
            nextAttemptAt: new Date(),
            sentAt: null,
            lastError: null,
          },
        },
        { upsert: true, session },
      )
      .exec();
  }

  async queuePush(
    session: ClientSession,
    input: {
      recipientUserId: string;
      recipientDeviceIds: string[];
      template: string;
      payload: Record<string, unknown>;
      dedupeKey: string;
    },
  ): Promise<void> {
    await this.notificationModel
      .updateOne(
        { dedupeKey: input.dedupeKey },
        {
          $setOnInsert: {
            _id: randomUUID(),
            channel: 'push',
            recipientUserId: input.recipientUserId,
            recipientEmail: null,
            recipientDeviceIds: input.recipientDeviceIds,
            template: input.template,
            payload: input.payload,
            dedupeKey: input.dedupeKey,
            status: 'pending',
            attemptCount: 0,
            nextAttemptAt: new Date(),
            sentAt: null,
            lastError: null,
          },
        },
        { upsert: true, session },
      )
      .exec();
  }

  get maxAutomaticAttempts(): number {
    return OUTBOX_MAX_AUTOMATIC_ATTEMPTS;
  }
}
