import {
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  MaxLength,
  Min,
} from 'class-validator';

export class CreateSettlementDto {
  @IsOptional()
  @IsString()
  id?: string;

  @IsString()
  paidByMemberId!: string;

  @IsString()
  paidToMemberId!: string;

  @IsInt()
  @Min(1)
  amountMinor!: number;

  @IsString()
  paymentDate!: string;

  @IsOptional()
  @IsString()
  @MaxLength(1000)
  note?: string;
}

export class ListSettlementsQueryDto {
  @IsOptional()
  @IsString()
  limit?: string;

  @IsOptional()
  @IsString()
  cursor?: string;

  @IsOptional()
  @IsIn(['pending', 'confirmed', 'rejected', 'cancelled'])
  status?: 'pending' | 'confirmed' | 'rejected' | 'cancelled';
}

export class RejectSettlementDto {
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  reason?: string;
}
