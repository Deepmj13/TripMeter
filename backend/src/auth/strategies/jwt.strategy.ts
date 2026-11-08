import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectModel } from '@nestjs/mongoose';
import { PassportStrategy } from '@nestjs/passport';
import { Model } from 'mongoose';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { User, UserDocument } from '../../database/schemas/user.schema';

export interface AccessTokenPayload {
  sub: string;
  familyId: string;
  pwc: number;
}

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    config: ConfigService,
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.get<string>('jwt.accessSecret', 'development-only-secret-change-me'),
    });
  }

  async validate(payload: AccessTokenPayload) {
    const user = await this.userModel
      .findOne({ _id: payload.sub, deletedAt: null })
      .select('+passwordHash passwordChangedAt emailVerifiedAt')
      .lean()
      .exec();

    if (!user) throw new UnauthorizedException('Session is no longer valid');

    const currentEpoch = Math.floor(user.passwordChangedAt.getTime() / 1000);
    if (payload.pwc !== currentEpoch) {
      throw new UnauthorizedException('Session is no longer valid');
    }

    return {
      userId: user._id,
      familyId: payload.familyId,
      emailVerifiedAt: user.emailVerifiedAt,
    };
  }
}
