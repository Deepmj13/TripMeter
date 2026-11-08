import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, SchemaTypes } from 'mongoose';
import { USER_EVENT_TYPES } from '../../common/constants';

@Schema({ timestamps: { createdAt: true, updatedAt: false }, versionKey: false, collection: 'userEvents' })
export class UserEvent {
  @Prop({ type: String, required: true })
  _id!: string;

  @Prop({ type: String, required: true })
  userId!: string;

  @Prop({ type: Number, required: true })
  sequence!: number;

  @Prop({ type: String, required: true, enum: USER_EVENT_TYPES })
  eventType!: (typeof USER_EVENT_TYPES)[number];

  @Prop({ type: String, default: null })
  tripId!: string | null;

  @Prop({ type: SchemaTypes.Mixed, required: true })
  payload!: Record<string, unknown>;
}

export type UserEventDocument = HydratedDocument<UserEvent>;
export const UserEventSchema = SchemaFactory.createForClass(UserEvent);

UserEventSchema.index({ userId: 1, sequence: 1 }, { unique: true });
UserEventSchema.index({ userId: 1, createdAt: 1 });
