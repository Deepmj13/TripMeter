import { Controller, Get, Param } from '@nestjs/common';
import { AuthenticatedUser, CurrentUser } from '../common/decorators';
import { BalancesService } from './balances.service';

@Controller('trips/:tripId')
export class BalancesController {
  constructor(private readonly balancesService: BalancesService) {}

  @Get('balances')
  balances(@CurrentUser() user: AuthenticatedUser, @Param('tripId') tripId: string) {
    return this.balancesService.balances(tripId, user.userId);
  }

  @Get('settlement-suggestions')
  suggestions(@CurrentUser() user: AuthenticatedUser, @Param('tripId') tripId: string) {
    return this.balancesService.settlementSuggestions(tripId, user.userId);
  }
}
