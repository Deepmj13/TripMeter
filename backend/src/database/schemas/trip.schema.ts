import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

@Schema({ timestamps: true, versionKey: false, collection: 'trips' })
export class Trip {
  @Prop({ type: String, required: true })
  _id!: string;

  @Prop({ type: String, required: true, maxlength: 120 })
  name!: string;

  @Prop({ type: String, default: '', maxlength: 200 })
  destination!: string;

  @Prop({ type: String, default: '', maxlength: 1000 })
  description!: string;

  @Prop({ type: String, required: true })
  currency!: string;

  @Prop({ type: Number, required: true })
  currencyExponent!: number;

  @Prop({ type: String, default: null })
  startDate!: string | null;

  @Prop({ type: String, default: null })
  endDate!: string | null;

  @Prop({ type: String, required: true })
  createdByUserId!: string;

  @Prop({ type: String, required: true })
  ownerUserId!: string;

  @Prop({ type: Number, default: 0 })
  syncVersion!: number;

  @Prop({ type: Date, default: null })
  archivedAt!: Date | null;
}

export type TripDocument = HydratedDocument<Trip>;
export const TripSchema = SchemaFactory.createForClass(Trip);

TripSchema.index({ ownerUserId: 1, archivedAt: 1, updatedAt: -1 });
TripSchema.index({ createdByUserId: 1 });
