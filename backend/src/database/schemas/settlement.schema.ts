import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';
import { MAX_AMOUNT_MINOR, SETTLEMENT_STATUSES } from '../../common/constants';

@Schema({ timestamps: { createdAt: true, updatedAt: false }, versionKey: false, collection: 'settlements' })
export class Settlement {
  @Prop({ type: String, required: true })
  _id!: string;

  @Prop({ type: String, required: true })
  tripId!: string;

  @Prop({ type: String, required: true })
  paidByMemberId!: string;

  @Prop({ type: String, required: true })
  paidToMemberId!: string;

  @Prop({
    type: Number,
    required: true,
    validate: {
      validator: (value: number) =>
        Number.isSafeInteger(value) && value > 0 && value <= MAX_AMOUNT_MINOR,
      message: 'amountMinor must be a positive safe integer within the allowed range',
    },
  })
  amountMinor!: number;

  @Prop({ type: String, required: true, match: /^\d{4}-\d{2}-\d{2}$/ })
  paymentDate!: string;

  @Prop({ type: String, enum: SETTLEMENT_STATUSES, required: true, default: 'pending' })
  status!: (typeof SETTLEMENT_STATUSES)[number];

  @Prop({ type: String, required: true })
  recordedByUserId!: string;

  @Prop({ type: String, default: null })
  confirmedByUserId!: string | null;

  @Prop({ type: String, default: null })
  statusChangedByUserId!: string | null;

  @Prop({ type: Date, default: null })
  statusChangedAt!: Date | null;

  @Prop({ type: String, default: null })
  rejectionReason!: string | null;

  @Prop({ type: String, default: '', maxlength: 1000 })
  note!: string;

  @Prop({ type: Number, required: true, default: 1, min: 1 })
  version!: number;

  @Prop({ type: Date, default: null })
  confirmedAt!: Date | null;
}

export type SettlementDocument = HydratedDocument<Settlement>;
export const SettlementSchema = SchemaFactory.createForClass(Settlement);

SettlementSchema.index({ tripId: 1, status: 1, paymentDate: -1 });
SettlementSchema.index({ tripId: 1, paidByMemberId: 1 });
SettlementSchema.index({ tripId: 1, paidToMemberId: 1 });
