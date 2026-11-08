import { Global, Module } from '@nestjs/common';
import { EventWriterService } from './services/event-writer.service';
import { IdempotencyService } from './services/idempotency.service';

@Global()
@Module({
  providers: [EventWriterService, IdempotencyService],
  exports: [EventWriterService, IdempotencyService],
})
export class CommonModule {}
