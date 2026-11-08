import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Cron, CronExpression } from '@nestjs/schedule';
import { Model } from 'mongoose';
import { OutboxMaxAttempts } from './outbox.constants';
import {
  NotificationOutbox,
  NotificationOutboxDocument,
} from '../database/schemas/notification-outbox.schema';

@Injectable()
export class OutboxDispatcherService {
  private readonly logger = new Logger(OutboxDispatcherService.name);
  private running = false;

  constructor(
    @InjectModel(NotificationOutbox.name)
    private readonly outboxModel: Model<NotificationOutboxDocument>,
  ) {}

  @Cron(CronExpression.EVERY_MINUTE)
  async dispatch(): Promise<void> {
    if (this.running) return;
    this.running = true;
    try {
      const now = new Date();
      for (let i = 0; i < 25; i += 1) {
        const record = await this.outboxModel
          .findOneAndUpdate(
            { status: 'pending', nextAttemptAt: { $lte: now } },
            { $set: { status: 'sending' } },
            { new: true },
          )
          .exec();
        if (!record) break;

        try {
          await this.deliver(record);
          record.status = 'sent';
          record.sentAt = new Date();
          record.lastError = null;
          await record.save();
        } catch (error) {
          const message = error instanceof Error ? error.message : String(error);
          record.attemptCount += 1;
          record.lastError = message.slice(0, 500);
          if (record.attemptCount >= OutboxMaxAttempts) {
            record.status = 'dead';
            this.logger.error(
              `Notification ${record._id} moved to dead letter: ${record.lastError}`,
            );
          } else {
            record.status = 'pending';
            record.nextAttemptAt = this.nextAttempt(record.attemptCount);
          }
          await record.save();
        }
      }
    } finally {
      this.running = false;
    }
  }

  private async deliver(
    record: NotificationOutboxDocument,
  ): Promise<void> {
    if (record.channel === 'email') {
      if (!record.recipientEmail) {
        throw new Error('Email recipient is missing');
      }
      // Provider integration is configured by environment in production. In
      // development the rendered template is logged so flows remain testable.
      if (process.env.EMAIL_PROVIDER_API_KEY) {
        await this.sendWithResend(record);
      } else {
        this.logger.log(
          `[email:${record.template}] -> ${record.recipientEmail} ${JSON.stringify(record.payload)}`,
        );
      }
      return;
    }

    this.logger.log(
      `[push:${record.template}] -> user ${record.recipientUserId} ${JSON.stringify(record.payload)}`,
    );
  }

  private async sendWithResend(
    record: NotificationOutboxDocument,
  ): Promise<void> {
    const apiKey = process.env.EMAIL_PROVIDER_API_KEY;
    if (!apiKey) return;

    const subject = String(record.payload.subject ?? record.template);
    const text = String(
      record.payload.text ?? JSON.stringify(record.payload, null, 2),
    );

    const response = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${apiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        from: process.env.EMAIL_FROM ?? 'Trip App <no-reply@example.com>',
        to: [record.recipientEmail],
        subject,
        text,
      }),
    });

    if (!response.ok) {
      throw new Error(`Email provider returned ${response.status}`);
    }
  }

  private nextAttempt(attemptCount: number): Date {
    const base = Math.min(300_000, 2_000 * 2 ** Math.max(0, attemptCount - 1));
    const jitter = Math.floor(Math.random() * 1_000);
    return new Date(Date.now() + base + jitter);
  }
}
