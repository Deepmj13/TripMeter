import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes } from 'mongoose';
import { EVENT_TYPES } from '../../common/constants';

@Schema({ timestamps: { createdAt: true, updatedAt: false }, versionKey: false, collection: 'tripEvents' })
export class TripEvent {
  @Prop({ type: String, required: true })
  _id!: string;

  @Prop({ type: String, required: true })
  tripId!: string;

  @Prop({ type: Number, required: true })
  sequence!: number;

  @Prop({ type: String, required: true, enum: EVENT_TYPES })
  eventType!: (typeof EVENT_TYPES)[number];

  @Prop({ type: String, required: true })
  entityType!: string;

  @Prop({ type: String, required: true })
  entityId!: string;

  @Prop({ type: String, required: true })
  actorUserId!: string;

  @Prop({ type: SchemaTypes.Mixed, required: true })
  payload!: Record<string, unknown>;
}

export type TripEventDocument = HydratedDocument<TripEvent>;
export const TripEventSchema = SchemaFactory.createForClass(TripEvent);

TripEventSchema.index({ tripId: 1, sequence: 1 }, { unique: true });
TripEventSchema.index({ tripId: 1, createdAt: 1 });
