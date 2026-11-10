import {
  Body,
  Controller,
  Get,
  Headers,
  Param,
  Post,
  Query,
  Res,
} from '@nestjs/common';
import { Response } from 'express';
import {
  AuthenticatedUser,
  CurrentUser,
  IdempotencyKey,
} from '../common/decorators';
import {
  CreateSettlementDto,
  ListSettlementsQueryDto,
  RejectSettlementDto,
} from './dto/settlements.dto';
import { SettlementsService } from './settlements.service';

@Controller('trips/:tripId/settlements')
export class SettlementsController {
  constructor(private readonly settlementsService: SettlementsService) {}

  @Post()
  create(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Body() dto: CreateSettlementDto,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.settlementsService.create(tripId, user.userId, dto, idempotencyKey);
  }

  @Get()
  list(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Query() query: ListSettlementsQueryDto,
  ) {
    return this.settlementsService.list(tripId, user.userId, query);
  }

  @Get(':settlementId')
  async get(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Param('settlementId') settlementId: string,
    @Res({ passthrough: true }) response: Response,
  ) {
    const settlement = await this.settlementsService.get(tripId, settlementId, user.userId);
    response.setHeader('ETag', `"${(settlement as { version: number }).version}"`);
    return settlement;
  }

  @Post(':settlementId/confirm')
  confirm(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Param('settlementId') settlementId: string,
    @Headers('if-match') ifMatch: string | undefined,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.settlementsService.confirm(
      tripId,
      settlementId,
      user.userId,
      ifMatch,
      idempotencyKey,
    );
  }

  @Post(':settlementId/reject')
  reject(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Param('settlementId') settlementId: string,
    @Body() dto: RejectSettlementDto,
    @Headers('if-match') ifMatch: string | undefined,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.settlementsService.reject(
      tripId,
      settlementId,
      user.userId,
      ifMatch,
      idempotencyKey,
      dto.reason,
    );
  }

  @Post(':settlementId/cancel')
  cancel(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Param('settlementId') settlementId: string,
    @Headers('if-match') ifMatch: string | undefined,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.settlementsService.cancel(
      tripId,
      settlementId,
      user.userId,
      ifMatch,
      idempotencyKey,
    );
  }
}
