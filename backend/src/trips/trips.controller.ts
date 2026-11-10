import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import {
  AuthenticatedUser,
  CurrentUser,
  IdempotencyKey,
} from '../common/decorators';
import {
  CreateTripDto,
  LeaveTripDto,
  TransferOwnershipDto,
  UpdateTripDto,
} from './dto/trips.dto';
import { TripsService } from './trips.service';

@Controller('trips')
export class TripsController {
  constructor(private readonly tripsService: TripsService) {}

  @Post()
  create(
    @CurrentUser() user: AuthenticatedUser,
    @Body() dto: CreateTripDto,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.tripsService.create(user.userId, dto, idempotencyKey);
  }

  @Get()
  list(@CurrentUser() user: AuthenticatedUser) {
    return this.tripsService.list(user.userId);
  }

  @Get(':tripId')
  get(@CurrentUser() user: AuthenticatedUser, @Param('tripId') tripId: string) {
    return this.tripsService.get(tripId, user.userId);
  }

  @Patch(':tripId')
  update(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Body() dto: UpdateTripDto,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.tripsService.update(tripId, user.userId, dto, idempotencyKey);
  }

  @Post(':tripId/archive')
  archive(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.tripsService.archive(tripId, user.userId, idempotencyKey);
  }

  @Post(':tripId/unarchive')
  unarchive(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.tripsService.unarchive(tripId, user.userId, idempotencyKey);
  }

  @Post(':tripId/transfer-ownership')
  transferOwnership(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Body() dto: TransferOwnershipDto,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.tripsService.transferOwnership(tripId, user.userId, dto, idempotencyKey);
  }

  @Post(':tripId/leave')
  leave(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Body() dto: LeaveTripDto,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.tripsService.leave(tripId, user.userId, dto, idempotencyKey);
  }

  @Get(':tripId/summary')
  summary(@CurrentUser() user: AuthenticatedUser, @Param('tripId') tripId: string) {
    return this.tripsService.summary(tripId, user.userId);
  }

  @Get(':tripId/audit')
  audit(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Query('after') after = '0',
    @Query('limit') limit = '50',
  ) {
    return this.tripsService.audit(
      tripId,
      user.userId,
      Number(after) || 0,
      Number(limit) || 50,
    );
  }
}
