import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes } from 'mongoose';

@Schema({ timestamps: { createdAt: true, updatedAt: false }, versionKey: false, collection: 'idempotencyRecords' })
export class IdempotencyRecord {
  @Prop({ type: String, required: true })
  _id!: string;

  @Prop({ type: String, required: true })
  actorUserId!: string;

  @Prop({ type: String, required: true })
  idempotencyKey!: string;

  @Prop({ type: String, required: true })
  requestHash!: string;

  @Prop({ type: Number, required: true })
  responseStatus!: number;

  @Prop({ type: SchemaTypes.Mixed, required: true })
  responseBody!: unknown;

  @Prop({ type: Date, required: true })
  expiresAt!: Date;
}

export type IdempotencyRecordDocument = HydratedDocument<IdempotencyRecord>;
export const IdempotencyRecordSchema = SchemaFactory.createForClass(IdempotencyRecord);

IdempotencyRecordSchema.index({ actorUserId: 1, idempotencyKey: 1 }, { unique: true });
IdempotencyRecordSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });
