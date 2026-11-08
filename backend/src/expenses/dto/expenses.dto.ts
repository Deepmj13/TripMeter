import {
  ArrayMaxSize,
  IsArray,
  IsIn,
  IsISO8601,
  IsInt,
  IsOptional,
  IsString,
  MaxLength,
  Min,
  MinLength,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import {
  EXPENSE_CATEGORIES,
  MAX_EXPENSE_PARTICIPANTS,
  SPLIT_TYPES,
} from '../../common/constants';

export class CreateSplitDto {
  @IsString()
  memberId!: string;

  @IsInt()
  @Min(0)
  amountMinor!: number;
}

export class CreateExpenseDto {
  @IsOptional()
  @IsString()
  id?: string;

  @IsString()
  @MinLength(1)
  @MaxLength(200)
  title!: string;

  @IsInt()
  @Min(1)
  amountMinor!: number;

  @IsString()
  paidByMemberId!: string;

  @IsIn(SPLIT_TYPES)
  splitType!: (typeof SPLIT_TYPES)[number];

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(MAX_EXPENSE_PARTICIPANTS)
  @IsString({ each: true })
  participantMemberIds?: string[];

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(MAX_EXPENSE_PARTICIPANTS)
  @ValidateNested({ each: true })
  @Type(() => CreateSplitDto)
  splits?: CreateSplitDto[];

  @IsString()
  expenseDate!: string;

  @IsOptional()
  @IsIn(EXPENSE_CATEGORIES)
  category?: (typeof EXPENSE_CATEGORIES)[number];

  @IsOptional()
  @IsString()
  @MaxLength(1000)
  description?: string;

  @IsOptional()
  @IsISO8601()
  clientCreatedAt?: string;
}

export class UpdateExpenseDto {
  @IsOptional()
  @IsString()
  @MinLength(1)
  @MaxLength(200)
  title?: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  amountMinor?: number;

  @IsOptional()
  @IsString()
  paidByMemberId?: string;

  @IsOptional()
  @IsIn(SPLIT_TYPES)
  splitType?: (typeof SPLIT_TYPES)[number];

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(MAX_EXPENSE_PARTICIPANTS)
  @IsString({ each: true })
  participantMemberIds?: string[];

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(MAX_EXPENSE_PARTICIPANTS)
  @ValidateNested({ each: true })
  @Type(() => CreateSplitDto)
  splits?: CreateSplitDto[];

  @IsOptional()
  @IsString()
  expenseDate?: string;

  @IsOptional()
  @IsIn(EXPENSE_CATEGORIES)
  category?: (typeof EXPENSE_CATEGORIES)[number];

  @IsOptional()
  @IsString()
  @MaxLength(1000)
  description?: string;
}

export class ListExpensesQueryDto {
  @IsOptional()
  @IsString()
  limit?: string;

  @IsOptional()
  @IsString()
  cursor?: string;

  @IsOptional()
  @IsString()
  fromDate?: string;

  @IsOptional()
  @IsString()
  toDate?: string;

  @IsOptional()
  @IsIn(EXPENSE_CATEGORIES)
  category?: (typeof EXPENSE_CATEGORIES)[number];

  @IsOptional()
  @IsString()
  memberId?: string;

  @IsOptional()
  @IsIn(['active', 'deleted'])
  status?: 'active' | 'deleted';
}
