import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Request } from 'express';
import { AppError } from '../../common/errors/app-error';
import {
  AuthenticatedUser,
  REQUIRES_VERIFIED_EMAIL_KEY,
} from '../../common/decorators';

@Injectable()
export class VerifiedEmailGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const required = this.reflector.getAllAndOverride<boolean>(REQUIRES_VERIFIED_EMAIL_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!required) return true;

    const request = context.switchToHttp().getRequest<Request & { user?: AuthenticatedUser }>();
    if (!request.user?.emailVerifiedAt) {
      throw new AppError(
        'AUTH_EMAIL_UNVERIFIED',
        'Verify your email address before performing this action',
        403,
      );
    }
    return true;
  }
}
