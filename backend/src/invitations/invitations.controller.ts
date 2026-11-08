import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import {
  AuthenticatedUser,
  CurrentUser,
  IdempotencyKey,
  RequiresVerifiedEmail,
} from '../common/decorators';
import {
  AcceptInvitationTokenDto,
  CreateInvitationDto,
  DeclineInvitationDto,
} from '../trips/dto/trips.dto';
import { InvitationsService } from './invitations.service';

@Controller('trips/:tripId/invitations')
export class TripInvitationsController {
  constructor(private readonly invitationsService: InvitationsService) {}

  @RequiresVerifiedEmail()
  @Post()
  create(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Body() dto: CreateInvitationDto,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.invitationsService.create(
      tripId,
      user.userId,
      dto,
      idempotencyKey,
    );
  }
}

@Controller('invitations')
export class InvitationsController {
  constructor(private readonly invitationsService: InvitationsService) {}

  @Get()
  list(@CurrentUser() user: AuthenticatedUser) {
    return this.invitationsService.list(user.userId);
  }

  @Post('accept')
  @RequiresVerifiedEmail()
  acceptByToken(
    @CurrentUser() user: AuthenticatedUser,
    @Body() dto: AcceptInvitationTokenDto,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.invitationsService.acceptByToken(user.userId, dto.token, idempotencyKey);
  }

  @Post('decline')
  decline(
    @CurrentUser() user: AuthenticatedUser,
    @Body() dto: DeclineInvitationDto,
  ) {
    return this.invitationsService.decline(user.userId, dto.token, dto.invitationId);
  }

  @Get(':invitationId')
  get(
    @CurrentUser() user: AuthenticatedUser,
    @Param('invitationId') invitationId: string,
  ) {
    return this.invitationsService.get(user.userId, invitationId);
  }

  @Post(':invitationId/resend')
  resend(
    @CurrentUser() user: AuthenticatedUser,
    @Param('invitationId') invitationId: string,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.invitationsService.resend(user.userId, invitationId, idempotencyKey);
  }

  @Post(':invitationId/revoke')
  revoke(
    @CurrentUser() user: AuthenticatedUser,
    @Param('invitationId') invitationId: string,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.invitationsService.revoke(user.userId, invitationId, idempotencyKey);
  }

  @Post(':invitationId/accept')
  @RequiresVerifiedEmail()
  acceptById(
    @CurrentUser() user: AuthenticatedUser,
    @Param('invitationId') invitationId: string,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.invitationsService.acceptById(user.userId, invitationId, idempotencyKey);
  }
}
