import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { randomUUID } from 'crypto';
import { AppError } from '../common/errors/app-error';
import { DeviceToken, DeviceTokenDocument } from '../database/schemas/device-token.schema';
import { User, UserDocument } from '../database/schemas/user.schema';
import {
  RegisterDeviceDto,
  UpdateNotificationPreferencesDto,
} from './dto/notifications.dto';

@Injectable()
export class NotificationsService {
  constructor(
    @InjectModel(DeviceToken.name)
    private readonly deviceModel: Model<DeviceTokenDocument>,
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
  ) {}

  async registerDevice(userId: string, dto: RegisterDeviceDto) {
    const now = new Date();
    const existing = await this.deviceModel.findOne({ deviceId: dto.deviceId }).exec();

    if (existing) {
      existing.userId = userId;
      existing.platform = dto.platform;
      existing.fcmToken = dto.fcmToken;
      existing.lastSeenAt = now;
      existing.revokedAt = null;
      await existing.save();
      return { deviceId: existing.deviceId, platform: existing.platform };
    }

    const device = await this.deviceModel.create({
      _id: randomUUID(),
      userId,
      deviceId: dto.deviceId,
      platform: dto.platform,
      fcmToken: dto.fcmToken,
      lastSeenAt: now,
      revokedAt: null,
    });

    return { deviceId: device.deviceId, platform: device.platform };
  }

  async unregisterDevice(userId: string, deviceId: string) {
    await this.deviceModel.updateOne(
      { userId, deviceId, revokedAt: null },
      { $set: { revokedAt: new Date() } },
    );
    return null;
  }

  async preferences(userId: string) {
    const user = await this.userModel.findById(userId).lean().exec();
    if (!user) throw AppError.notFound('TRIP_NOT_FOUND', 'Account not found');
    return user.notificationPreferences;
  }

  async updatePreferences(
    userId: string,
    dto: UpdateNotificationPreferencesDto,
  ) {
    const user = await this.userModel.findById(userId).exec();
    if (!user) throw AppError.notFound('TRIP_NOT_FOUND', 'Account not found');

    user.notificationPreferences = {
      ...user.notificationPreferences,
      ...dto,
    };
    await user.save();
    return user.notificationPreferences;
  }
}
