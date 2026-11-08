import { Module } from '@nestjs/common';
import { TripsModule } from '../trips/trips.module';
import { SyncService } from './sync.service';
import { TripSyncController, UserSyncController } from './sync.controller';

@Module({
  imports: [TripsModule],
  controllers: [UserSyncController, TripSyncController],
  providers: [SyncService],
  exports: [SyncService],
})
export class SyncModule {}
