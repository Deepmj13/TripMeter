import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';
import {
  EXPENSE_CATEGORIES,
  MAX_AMOUNT_MINOR,
  MAX_EXPENSE_PARTICIPANTS,
  SPLIT_TYPES,
} from '../../common/constants';

@Schema({ _id: false })
export class ExpenseSplit {
  @Prop({ type: String, required: true })
  memberId!: string;

  @Prop({
    type: Number,
    required: true,
    min: 0,
    validate: {
      validator: (value: number) =>
        Number.isSafeInteger(value) && value >= 0 && value <= MAX_AMOUNT_MINOR,
      message: 'split amount must be a safe integer within the allowed range',
    },
  })
  amountMinor!: number;
}

export const ExpenseSplitSchema = SchemaFactory.createForClass(ExpenseSplit);

@Schema({ timestamps: true, versionKey: false, collection: 'expenses' })
export class Expense {
  @Prop({ type: String, required: true })
  _id!: string;

  @Prop({ type: String, required: true })
  tripId!: string;

  @Prop({ type: String, required: true, maxlength: 200 })
  title!: string;

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

  @Prop({ type: String, required: true })
  currency!: string;

  @Prop({ type: String, required: true })
  paidByMemberId!: string;

  @Prop({ type: String, required: true })
  createdByUserId!: string;

  @Prop({ type: String, default: null })
  updatedByUserId!: string | null;

  @Prop({ type: String, default: null })
  deletedByUserId!: string | null;

  @Prop({ type: String, enum: SPLIT_TYPES, required: true })
  splitType!: (typeof SPLIT_TYPES)[number];

  @Prop({
    type: [ExpenseSplitSchema],
    required: true,
    validate: {
      validator: (splits: ExpenseSplit[]) =>
        Array.isArray(splits) &&
        splits.length > 0 &&
        splits.length <= MAX_EXPENSE_PARTICIPANTS,
      message: 'expense must have between 1 and 100 splits',
    },
  })
  splits!: ExpenseSplit[];

  @Prop({ type: String, required: true, match: /^\d{4}-\d{2}-\d{2}$/ })
  expenseDate!: string;

  @Prop({ type: String, enum: EXPENSE_CATEGORIES, default: 'other' })
  category!: (typeof EXPENSE_CATEGORIES)[number];

  @Prop({ type: String, default: '', maxlength: 1000 })
  description!: string;

  @Prop({ type: String, enum: ['active', 'deleted'], default: 'active' })
  status!: 'active' | 'deleted';

  @Prop({ type: Number, required: true, default: 1, min: 1 })
  version!: number;

  @Prop({ type: Date, required: true })
  clientCreatedAt!: Date;

  @Prop({ type: Date, default: null })
  deletedAt!: Date | null;
}

export type ExpenseDocument = HydratedDocument<Expense>;
export const ExpenseSchema = SchemaFactory.createForClass(Expense);

ExpenseSchema.index({ tripId: 1, status: 1, expenseDate: -1, _id: -1 });
ExpenseSchema.index({ tripId: 1, paidByMemberId: 1, expenseDate: -1 });
ExpenseSchema.index({ tripId: 1, 'splits.memberId': 1 });
ExpenseSchema.index({ tripId: 1, createdByUserId: 1, createdAt: -1 });
