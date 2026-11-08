import { Module } from '@nestjs/common';
import { NotificationsController } from './notifications.controller';
import { NotificationsService } from './notifications.service';
import { OutboxDispatcherService } from './outbox-dispatcher.service';

@Module({
  controllers: [NotificationsController],
  providers: [NotificationsService, OutboxDispatcherService],
  exports: [NotificationsService],
})
export class NotificationsModule {}
