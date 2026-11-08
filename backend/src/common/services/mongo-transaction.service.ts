import { Injectable } from '@nestjs/common';
import { InjectConnection } from '@nestjs/mongoose';
import { ClientSession, Connection } from 'mongoose';

@Injectable()
export class MongoTransactionService {
  constructor(@InjectConnection() private readonly connection: Connection) {}

  /**
   * Runs a multi-document transaction with snapshot reads and majority writes.
   * `withTransaction` retries transient errors and write conflicts.
   */
  async run<T>(work: (session: ClientSession) => Promise<T>): Promise<T> {
    const session = await this.connection.startSession();
    try {
      let result: T | undefined;
      await session.withTransaction(
        async () => {
          result = await work(session);
        },
        {
          readConcern: { level: 'snapshot' },
          writeConcern: { w: 'majority' },
          readPreference: 'primary',
        },
      );
      if (result === undefined) {
        throw new Error('Transaction completed without a result');
      }
      return result;
    } finally {
      await session.endSession();
    }
  }
}
