import { Controller, Get, Param, Query } from '@nestjs/common';
import { AuthenticatedUser, CurrentUser } from '../common/decorators';
import { SyncService } from './sync.service';

@Controller('users/me')
export class UserSyncController {
  constructor(private readonly syncService: SyncService) {}

  @Get('changes')
  changes(
    @CurrentUser() user: AuthenticatedUser,
    @Query('after') after = '0',
    @Query('limit') limit = '100',
  ) {
    return this.syncService.userChanges(
      user.userId,
      Number(after) || 0,
      Number(limit) || 100,
    );
  }

  @Get('sync-status')
  status(@CurrentUser() user: AuthenticatedUser) {
    return this.syncService.userSyncStatus(user.userId);
  }

  @Get('snapshot')
  snapshot(@CurrentUser() user: AuthenticatedUser) {
    return this.syncService.userSnapshot(user.userId);
  }
}

@Controller('trips/:tripId')
export class TripSyncController {
  constructor(private readonly syncService: SyncService) {}

  @Get('changes')
  changes(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Query('after') after = '0',
    @Query('limit') limit = '100',
  ) {
    return this.syncService.tripChanges(
      tripId,
      user.userId,
      Number(after) || 0,
      Number(limit) || 100,
    );
  }

  @Get('sync-status')
  status(@CurrentUser() user: AuthenticatedUser, @Param('tripId') tripId: string) {
    return this.syncService.tripSyncStatus(tripId, user.userId);
  }

  @Get('snapshot')
  snapshot(@CurrentUser() user: AuthenticatedUser, @Param('tripId') tripId: string) {
    return this.syncService.tripSnapshot(tripId, user.userId);
  }
}
