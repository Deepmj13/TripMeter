import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

@Schema({ _id: false })
export class NotificationPreferences {
  @Prop({ type: Boolean, default: true })
  push!: boolean;

  @Prop({ type: Boolean, default: true })
  email!: boolean;

  @Prop({ type: Boolean, default: true })
  invitations!: boolean;

  @Prop({ type: Boolean, default: true })
  expenses!: boolean;

  @Prop({ type: Boolean, default: true })
  settlements!: boolean;
}

export const NotificationPreferencesSchema = SchemaFactory.createForClass(
  NotificationPreferences,
);

@Schema({ timestamps: true, versionKey: false, collection: 'users' })
export class User {
  @Prop({ type: String, required: true })
  _id!: string;

  @Prop({ type: String, required: true, maxlength: 120 })
  name!: string;

  @Prop({ type: String, required: true })
  email!: string;

  @Prop({ type: String, required: true })
  emailNormalized!: string;

  @Prop({ type: String, required: true, select: false })
  passwordHash!: string;

  @Prop({ type: Date, required: true })
  passwordChangedAt!: Date;

  @Prop({ type: Date, default: null })
  emailVerifiedAt!: Date | null;

  @Prop({ type: NotificationPreferencesSchema, default: () => ({}) })
  notificationPreferences!: NotificationPreferences;

  @Prop({ type: Number, default: 0 })
  syncVersion!: number;

  @Prop({ type: Date, default: null })
  deletedAt!: Date | null;
}

export type UserDocument = HydratedDocument<User>;
export const UserSchema = SchemaFactory.createForClass(User);

UserSchema.index({ emailNormalized: 1 }, { unique: true });
