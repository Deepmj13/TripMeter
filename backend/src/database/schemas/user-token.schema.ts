import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export type UserTokenType = 'password_reset';

@Schema({ timestamps: { createdAt: true, updatedAt: false }, versionKey: false, collection: 'userTokens' })
export class UserToken {
  @Prop({ type: String, required: true })
  _id!: string;

  @Prop({ type: String, required: true })
  userId!: string;

  @Prop({ type: String, required: true, enum: ['password_reset'] })
  type!: UserTokenType;

  @Prop({ type: String, required: true })
  tokenHash!: string;

  @Prop({ type: Date, required: true })
  expiresAt!: Date;

  @Prop({ type: Date, default: null })
  usedAt!: Date | null;

  @Prop({ type: Date, default: null })
  revokedAt!: Date | null;
}

export type UserTokenDocument = HydratedDocument<UserToken>;
export const UserTokenSchema = SchemaFactory.createForClass(UserToken);

UserTokenSchema.index({ tokenHash: 1 }, { unique: true });
UserTokenSchema.index({ userId: 1, type: 1, usedAt: 1, revokedAt: 1 });
