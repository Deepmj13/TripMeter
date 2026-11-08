import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';
import { MEMBER_KINDS, MEMBER_ROLES, MEMBER_STATUSES } from '../../common/constants';

@Schema({ timestamps: true, versionKey: false, collection: 'tripMembers' })
export class TripMember {
  @Prop({ type: String, required: true })
  _id!: string;

  @Prop({ type: String, required: true })
  tripId!: string;

  @Prop({ type: String, default: null })
  userId!: string | null;

  @Prop({ type: String, required: true, maxlength: 120 })
  displayName!: string;

  @Prop({ type: String, default: null })
  emailNormalized!: string | null;

  @Prop({ type: String, required: true, enum: MEMBER_KINDS })
  memberKind!: (typeof MEMBER_KINDS)[number];

  @Prop({ type: String, required: true, enum: MEMBER_ROLES })
  role!: (typeof MEMBER_ROLES)[number];

  @Prop({ type: String, required: true, enum: MEMBER_STATUSES })
  status!: (typeof MEMBER_STATUSES)[number];

  @Prop({ type: String, required: true })
  createdByUserId!: string;

  @Prop({ type: Date, default: null })
  joinedAt!: Date | null;
}

export type TripMemberDocument = HydratedDocument<TripMember>;
export const TripMemberSchema = SchemaFactory.createForClass(TripMember);

TripMemberSchema.index(
  { tripId: 1, userId: 1 },
  { unique: true, partialFilterExpression: { userId: { $type: 'string' } } },
);
TripMemberSchema.index(
  { tripId: 1, emailNormalized: 1 },
  { unique: true, partialFilterExpression: { emailNormalized: { $type: 'string' } } },
);
TripMemberSchema.index({ tripId: 1, status: 1 });
TripMemberSchema.index({ userId: 1, status: 1 });
TripMemberSchema.index({ tripId: 1, memberKind: 1, status: 1 });
