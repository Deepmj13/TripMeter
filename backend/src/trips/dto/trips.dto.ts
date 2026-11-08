import {
  IsEmail,
  IsIn,
  IsOptional,
  IsString,
  MaxLength,
  MinLength,
} from 'class-validator';
import { SUPPORTED_CURRENCIES } from '../../common/constants';

export class CreateTripDto {
  @IsOptional()
  @IsString()
  id?: string;

  @IsString()
  @MinLength(1)
  @MaxLength(120)
  name!: string;

  @IsOptional()
  @IsString()
  @MaxLength(200)
  destination?: string;

  @IsOptional()
  @IsString()
  @MaxLength(1000)
  description?: string;

  @IsOptional()
  @IsIn(Object.keys(SUPPORTED_CURRENCIES))
  currency?: string;

  @IsOptional()
  @IsString()
  startDate?: string;

  @IsOptional()
  @IsString()
  endDate?: string;
}

export class UpdateTripDto {
  @IsOptional()
  @IsString()
  @MinLength(1)
  @MaxLength(120)
  name?: string;

  @IsOptional()
  @IsString()
  @MaxLength(200)
  destination?: string;

  @IsOptional()
  @IsString()
  @MaxLength(1000)
  description?: string;

  @IsOptional()
  @IsString()
  startDate?: string;

  @IsOptional()
  @IsString()
  endDate?: string;

  @IsOptional()
  @IsString()
  currency?: string;
}

export class TransferOwnershipDto {
  @IsString()
  memberId!: string;
}

export class LeaveTripDto {
  @IsOptional()
  acknowledgeOutstandingBalance?: boolean;
}

export class CreateInvitationDto {
  @IsEmail()
  @MaxLength(254)
  email!: string;
}

export class CreateGuestMemberDto {
  @IsOptional()
  @IsString()
  id?: string;

  @IsString()
  @MinLength(1)
  @MaxLength(120)
  displayName!: string;

  @IsOptional()
  @IsEmail()
  @MaxLength(254)
  email?: string;
}

export class UpdateMemberDto {
  @IsOptional()
  @IsString()
  @MinLength(1)
  @MaxLength(120)
  displayName?: string;

  @IsOptional()
  @IsEmail()
  @MaxLength(254)
  email?: string;
}

export class ChangeRoleDto {
  @IsIn(['admin', 'member'])
  role!: 'admin' | 'member';
}

export class AcceptInvitationTokenDto {
  @IsString()
  @MinLength(1)
  token!: string;
}

export class DeclineInvitationDto {
  @IsOptional()
  @IsString()
  token?: string;

  @IsOptional()
  @IsString()
  invitationId?: string;
}
