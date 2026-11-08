import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
} from '@nestjs/common';
import {
  AuthenticatedUser,
  CurrentUser,
  IdempotencyKey,
  RequiresVerifiedEmail,
} from '../common/decorators';
import {
  ChangeRoleDto,
  CreateGuestMemberDto,
  UpdateMemberDto,
} from '../trips/dto/trips.dto';
import { MembersService } from './members.service';

@Controller('trips/:tripId/members')
export class MembersController {
  constructor(private readonly membersService: MembersService) {}

  @Get()
  list(@CurrentUser() user: AuthenticatedUser, @Param('tripId') tripId: string) {
    return this.membersService.list(tripId, user.userId);
  }

  @Get(':memberId')
  get(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Param('memberId') memberId: string,
  ) {
    return this.membersService.get(tripId, user.userId, memberId);
  }

  @RequiresVerifiedEmail()
  @Post()
  addGuest(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Body() dto: CreateGuestMemberDto,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.membersService.addGuest(tripId, user.userId, dto, idempotencyKey);
  }

  @Patch(':memberId')
  update(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Param('memberId') memberId: string,
    @Body() dto: UpdateMemberDto,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.membersService.update(
      tripId,
      user.userId,
      memberId,
      dto,
      idempotencyKey,
    );
  }

  @Patch(':memberId/role')
  changeRole(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Param('memberId') memberId: string,
    @Body() dto: ChangeRoleDto,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.membersService.changeRole(
      tripId,
      user.userId,
      memberId,
      dto,
      idempotencyKey,
    );
  }

  @Post(':memberId/remove')
  remove(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Param('memberId') memberId: string,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.membersService.remove(tripId, user.userId, memberId, idempotencyKey);
  }

  @RequiresVerifiedEmail()
  @Post(':memberId/claim')
  claim(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Param('memberId') memberId: string,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.membersService.claim(tripId, user.userId, memberId, idempotencyKey);
  }
}
