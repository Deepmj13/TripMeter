import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Cron, CronExpression } from '@nestjs/schedule';
import { Model } from 'mongoose';
import {
  EVENT_RETENTION_DAYS,
  EVENT_RETENTION_COUNT,
} from '../constants';
import { addDays } from '../utils/dates';
import { IdempotencyRecord, IdempotencyRecordDocument } from '../../database/schemas/idempotency-record.schema';
import { TripEvent, TripEventDocument } from '../../database/schemas/trip-event.schema';
import { UserEvent, UserEventDocument } from '../../database/schemas/user-event.schema';
import { UserToken, UserTokenDocument } from '../../database/schemas/user-token.schema';

@Injectable()
export class RetentionService {
  private readonly logger = new Logger(RetentionService.name);

  constructor(
    @InjectModel(TripEvent.name) private readonly tripEventModel: Model<TripEventDocument>,
    @InjectModel(UserEvent.name) private readonly userEventModel: Model<UserEventDocument>,
    @InjectModel(IdempotencyRecord.name)
    private readonly idempotencyModel: Model<IdempotencyRecordDocument>,
    @InjectModel(UserToken.name) private readonly userTokenModel: Model<UserTokenDocument>,
  ) {}

  @Cron(CronExpression.EVERY_DAY_AT_3AM)
  async cleanup(): Promise<void> {
    const now = new Date();
    const olderThan = addDays(now, -EVENT_RETENTION_DAYS);

    await this.pruneTripEvents(olderThan);
    await this.pruneUserEvents(olderThan);

    const expiredIdempotency = await this.idempotencyModel.deleteMany({
      expiresAt: { $lte: now },
    });
    const expiredTokens = await this.userTokenModel.deleteMany({
      expiresAt: { $lte: addDays(now, -7) },
    });

    this.logger.log(
      `Retention cleanup: idempotency=${expiredIdempotency.deletedCount}, userTokens=${expiredTokens.deletedCount}`,
    );
  }

  private async pruneTripEvents(olderThan: Date): Promise<void> {
    const trips = await this.tripEventModel.distinct('tripId');
    let deleted = 0;
    for (const tripId of trips) {
      const count = await this.tripEventModel
        .countDocuments({ tripId })
        .exec();
      const removable = count - EVENT_RETENTION_COUNT;
      if (removable <= 0) continue;

      const threshold = await this.tripEventModel
        .find({ tripId })
        .sort({ sequence: 1 })
        .skip(removable - 1)
        .limit(1)
        .lean()
        .exec();
      if (!threshold[0]) continue;

      const result = await this.tripEventModel.deleteMany({
        tripId,
        sequence: { $lte: threshold[0].sequence },
        createdAt: { $lt: olderThan },
      });
      deleted += result.deletedCount ?? 0;
    }
    if (deleted > 0) this.logger.log(`Pruned ${deleted} trip events`);
  }

  private async pruneUserEvents(olderThan: Date): Promise<void> {
    const users = await this.userEventModel.distinct('userId');
    let deleted = 0;
    for (const userId of users) {
      const count = await this.userEventModel.countDocuments({ userId }).exec();
      const removable = count - EVENT_RETENTION_COUNT;
      if (removable <= 0) continue;

      const threshold = await this.userEventModel
        .find({ userId })
        .sort({ sequence: 1 })
        .skip(removable - 1)
        .limit(1)
        .lean()
        .exec();
      if (!threshold[0]) continue;

      const result = await this.userEventModel.deleteMany({
        userId,
        sequence: { $lte: threshold[0].sequence },
        createdAt: { $lt: olderThan },
      });
      deleted += result.deletedCount ?? 0;
    }
    if (deleted > 0) this.logger.log(`Pruned ${deleted} user events`);
  }
}
