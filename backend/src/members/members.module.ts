import { Module } from '@nestjs/common';
import { TripsModule } from '../trips/trips.module';
import { MembersController } from './members.controller';
import { MembersService } from './members.service';

@Module({
  imports: [TripsModule],
  controllers: [MembersController],
  providers: [MembersService],
  exports: [MembersService],
})
export class MembersModule {}
