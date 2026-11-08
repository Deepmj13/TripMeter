import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { ClientSession, Model } from 'mongoose';
import { randomUUID } from 'crypto';
import {
  IdempotencyRecord,
  IdempotencyRecordDocument,
} from '../../database/schemas/idempotency-record.schema';
import { AppError } from '../errors/app-error';
import { IDEMPOTENCY_RETENTION_DAYS } from '../constants';
import { addDays } from '../utils/dates';
import { MongoTransactionService } from './mongo-transaction.service';

export interface IdempotentResult<T> {
  status: number;
  body: T;
}

@Injectable()
export class IdempotencyService {
  constructor(
    @InjectModel(IdempotencyRecord.name)
    private readonly recordModel: Model<IdempotencyRecordDocument>,
    private readonly transactions: MongoTransactionService,
  ) {}

  async execute<T>(
    actorUserId: string,
    idempotencyKey: string | undefined,
    requestHash: string,
    handler: (session: ClientSession) => Promise<IdempotentResult<T>>,
  ): Promise<T> {
    if (!idempotencyKey) {
      throw new AppError(
        'PRECONDITION_REQUIRED',
        'The Idempotency-Key header is required for this operation',
        428,
      );
    }

    const existing = await this.recordModel
      .findOne({ actorUserId, idempotencyKey })
      .lean()
      .exec();
    if (existing) {
      this.assertSameRequest(existing.requestHash, requestHash);
      return existing.responseBody as T;
    }

    try {
      return await this.transactions.run(async (session) => {
        const inTransaction = await this.recordModel
          .findOne({ actorUserId, idempotencyKey }, null, { session })
          .lean()
          .exec();
        if (inTransaction) {
          this.assertSameRequest(inTransaction.requestHash, requestHash);
          return inTransaction.responseBody as T;
        }

        const result = await handler(session);

        await this.recordModel.create(
          [
            {
              _id: randomUUID(),
              actorUserId,
              idempotencyKey,
              requestHash,
              responseStatus: result.status,
              responseBody: result.body,
              expiresAt: addDays(new Date(), IDEMPOTENCY_RETENTION_DAYS),
            },
          ],
          { session },
        );

        return result.body;
      });
    } catch (error) {
      if (this.isDuplicateKey(error)) {
        const raced = await this.recordModel
          .findOne({ actorUserId, idempotencyKey })
          .lean()
          .exec();
        if (raced) {
          this.assertSameRequest(raced.requestHash, requestHash);
          return raced.responseBody as T;
        }
      }
      throw error;
    }
  }

  private assertSameRequest(storedHash: string, requestHash: string): void {
    if (storedHash !== requestHash) {
      throw new AppError(
        'IDEMPOTENCY_KEY_REUSED',
        'This Idempotency-Key was already used with a different request',
        409,
      );
    }
  }

  private isDuplicateKey(error: unknown): boolean {
    return (
      typeof error === 'object' &&
      error !== null &&
      (error as { code?: number }).code === 11000
    );
  }
}
