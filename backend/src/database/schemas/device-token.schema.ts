import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

@Schema({ timestamps: true, versionKey: false, collection: 'deviceTokens' })
export class DeviceToken {
  @Prop({ type: String, required: true })
  _id!: string;

  @Prop({ type: String, required: true })
  userId!: string;

  @Prop({ type: String, required: true })
  deviceId!: string;

  @Prop({ type: String, required: true, enum: ['android', 'ios', 'web'] })
  platform!: 'android' | 'ios' | 'web';

  @Prop({ type: String, required: true })
  fcmToken!: string;

  @Prop({ type: Date, default: null })
  lastSeenAt!: Date | null;

  @Prop({ type: Date, default: null })
  revokedAt!: Date | null;
}

export type DeviceTokenDocument = HydratedDocument<DeviceToken>;
export const DeviceTokenSchema = SchemaFactory.createForClass(DeviceToken);

DeviceTokenSchema.index({ deviceId: 1 }, { unique: true });
DeviceTokenSchema.index({ userId: 1, revokedAt: 1 });
DeviceTokenSchema.index({ fcmToken: 1 });
