import { Global, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';
import {
  DeviceToken,
  DeviceTokenSchema,
  Expense,
  ExpenseSchema,
  IdempotencyRecord,
  IdempotencyRecordSchema,
  NotificationOutbox,
  NotificationOutboxSchema,
  RefreshToken,
  RefreshTokenSchema,
  Settlement,
  SettlementSchema,
  Trip,
  TripEvent,
  TripEventSchema,
  TripInvitation,
  TripInvitationSchema,
  TripMember,
  TripMemberSchema,
  TripSchema,
  User,
  UserEvent,
  UserEventSchema,
  UserSchema,
  UserToken,
  UserTokenSchema,
} from './schemas';
import { MongoTransactionService } from '../common/services/mongo-transaction.service';

export const MONGOOSE_MODELS = MongooseModule.forFeature([
  { name: User.name, schema: UserSchema },
  { name: RefreshToken.name, schema: RefreshTokenSchema },
  { name: UserToken.name, schema: UserTokenSchema },
  { name: Trip.name, schema: TripSchema },
  { name: TripMember.name, schema: TripMemberSchema },
  { name: TripInvitation.name, schema: TripInvitationSchema },
  { name: Expense.name, schema: ExpenseSchema },
  { name: Settlement.name, schema: SettlementSchema },
  { name: TripEvent.name, schema: TripEventSchema },
  { name: UserEvent.name, schema: UserEventSchema },
  { name: IdempotencyRecord.name, schema: IdempotencyRecordSchema },
  { name: DeviceToken.name, schema: DeviceTokenSchema },
  { name: NotificationOutbox.name, schema: NotificationOutboxSchema },
]);

@Global()
@Module({
  imports: [
    MongooseModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        uri: config.get<string>('MONGODB_URI', 'mongodb://localhost:27017/tripmeter'),
        autoIndex: config.get<string>('NODE_ENV') !== 'production',
        serverSelectionTimeoutMS: 5000,
      }),
    }),
    MONGOOSE_MODELS,
  ],
  providers: [MongoTransactionService],
  exports: [MONGOOSE_MODELS, MongoTransactionService],
})
export class DatabaseModule {}
