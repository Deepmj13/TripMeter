import { Module } from '@nestjs/common';
import { TripsModule } from '../trips/trips.module';
import {
  InvitationsController,
  TripInvitationsController,
} from './invitations.controller';
import { InvitationsService } from './invitations.service';

@Module({
  imports: [TripsModule],
  controllers: [TripInvitationsController, InvitationsController],
  providers: [InvitationsService],
  exports: [InvitationsService],
})
export class InvitationsModule {}
