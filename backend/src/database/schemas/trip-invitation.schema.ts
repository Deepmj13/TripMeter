import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

export const INVITATION_STATUSES = [
  'pending',
  'accepted',
  'declined',
  'revoked',
  'expired',
] as const;
export type InvitationStatus = (typeof INVITATION_STATUSES)[number];

@Schema({ timestamps: true, versionKey: false, collection: 'tripInvitations' })
export class TripInvitation {
  @Prop({ type: String, required: true })
  _id!: string;

  @Prop({ type: String, required: true })
  tripId!: string;

  @Prop({ type: String, required: true })
  memberId!: string;

  @Prop({ type: String, required: true })
  invitedByUserId!: string;

  @Prop({ type: String, required: true })
  emailNormalized!: string;

  @Prop({ type: String, required: true })
  tokenHash!: string;

  @Prop({ type: String, required: true, enum: INVITATION_STATUSES, default: 'pending' })
  status!: InvitationStatus;

  @Prop({ type: Date, required: true })
  expiresAt!: Date;

  @Prop({ type: Date, default: null })
  acceptedAt!: Date | null;

  @Prop({ type: Date, default: null })
  respondedAt!: Date | null;

  @Prop({ type: Date, default: null })
  revokedAt!: Date | null;
}

export type TripInvitationDocument = HydratedDocument<TripInvitation>;
export const TripInvitationSchema = SchemaFactory.createForClass(TripInvitation);

TripInvitationSchema.index({ tokenHash: 1 }, { unique: true });
TripInvitationSchema.index(
  { tripId: 1, emailNormalized: 1 },
  { unique: true, partialFilterExpression: { status: 'pending' } },
);
TripInvitationSchema.index({ emailNormalized: 1, status: 1 });
TripInvitationSchema.index({ tripId: 1, status: 1 });
TripInvitationSchema.index({ memberId: 1 });
