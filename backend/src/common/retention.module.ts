import { Module } from '@nestjs/common';
import { RetentionService } from './services/retention.service';

@Module({
  providers: [RetentionService],
})
export class RetentionModule {}
