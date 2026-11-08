import { createParamDecorator, ExecutionContext, SetMetadata } from '@nestjs/common';
import { Request } from 'express';

export const IS_PUBLIC_KEY = 'isPublic';
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);

export const REQUIRES_VERIFIED_EMAIL_KEY = 'requiresVerifiedEmail';
export const RequiresVerifiedEmail = () => SetMetadata(REQUIRES_VERIFIED_EMAIL_KEY, true);

export interface AuthenticatedUser {
  userId: string;
  familyId: string;
  emailVerifiedAt: Date | null;
}

export const CurrentUser = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): AuthenticatedUser => {
    const request = ctx.switchToHttp().getRequest<Request & { user: AuthenticatedUser }>();
    return request.user;
  },
);

export const IdempotencyKey = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): string | undefined => {
    const request = ctx.switchToHttp().getRequest<Request>();
    return request.header('idempotency-key') ?? undefined;
  },
);

export const RequestId = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): string => {
    const request = ctx.switchToHttp().getRequest<Request & { requestId?: string }>();
    return request.requestId ?? 'unknown';
  },
);
