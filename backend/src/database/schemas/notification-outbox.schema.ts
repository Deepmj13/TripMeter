import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes } from 'mongoose';

export const NOTIFICATION_STATUSES = ['pending', 'sending', 'sent', 'dead'] as const;
export type NotificationStatus = (typeof NOTIFICATION_STATUSES)[number];

@Schema({ timestamps: { createdAt: true, updatedAt: false }, versionKey: false, collection: 'notificationOutbox' })
export class NotificationOutbox {
  @Prop({ type: String, required: true })
  _id!: string;

  @Prop({ type: String, required: true, enum: ['email', 'push'] })
  channel!: 'email' | 'push';

  @Prop({ type: String, default: null })
  recipientUserId!: string | null;

  @Prop({ type: String, default: null })
  recipientEmail!: string | null;

  @Prop({ type: [String], default: [] })
  recipientDeviceIds!: string[];

  @Prop({ type: String, required: true })
  template!: string;

  @Prop({ type: SchemaTypes.Mixed, default: {} })
  payload!: Record<string, unknown>;

  @Prop({ type: String, required: true })
  dedupeKey!: string;

  @Prop({ type: String, required: true, enum: NOTIFICATION_STATUSES, default: 'pending' })
  status!: NotificationStatus;

  @Prop({ type: Number, default: 0 })
  attemptCount!: number;

  @Prop({ type: Date, required: true })
  nextAttemptAt!: Date;

  @Prop({ type: Date, default: null })
  sentAt!: Date | null;

  @Prop({ type: String, default: null })
  lastError!: string | null;
}

export type NotificationOutboxDocument = HydratedDocument<NotificationOutbox>;
export const NotificationOutboxSchema = SchemaFactory.createForClass(NotificationOutbox);

NotificationOutboxSchema.index({ dedupeKey: 1 }, { unique: true });
NotificationOutboxSchema.index({ status: 1, nextAttemptAt: 1 });
