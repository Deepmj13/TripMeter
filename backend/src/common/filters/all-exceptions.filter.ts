import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { AppError, ErrorCode } from '../errors/app-error';

interface ErrorBody {
  success: false;
  error: {
    code: ErrorCode | string;
    message: string;
    details?: Record<string, unknown>;
  };
  requestId: string;
}

@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger(AllExceptionsFilter.name);

  catch(exception: unknown, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request & { requestId?: string }>();
    const requestId = request.requestId ?? 'unknown';

    const body = this.toErrorBody(exception, requestId);

    if (body.error.code === 'INTERNAL_ERROR') {
      this.logger.error(
        `${request.method} ${request.url} requestId=${requestId}`,
        exception instanceof Error ? exception.stack : String(exception),
      );
    }

    response.status(body.error.code === 'INTERNAL_ERROR' ? HttpStatus.INTERNAL_SERVER_ERROR : this.statusFor(exception)).json(body);
  }

  private statusFor(exception: unknown): number {
    if (exception instanceof AppError) return exception.status;
    if (exception instanceof HttpException) return exception.getStatus();
    return HttpStatus.INTERNAL_SERVER_ERROR;
  }

  private toErrorBody(exception: unknown, requestId: string): ErrorBody {
    if (exception instanceof AppError) {
      return {
        success: false,
        error: {
          code: exception.code,
          message: exception.message,
          ...(exception.details ? { details: exception.details } : {}),
        },
        requestId,
      };
    }

    if (exception instanceof HttpException) {
      const status = exception.getStatus();
      const payload = exception.getResponse();
      const message =
        typeof payload === 'string'
          ? payload
          : Array.isArray((payload as { message?: unknown }).message)
            ? 'The request is invalid'
            : ((payload as { message?: string }).message ?? exception.message);
      const details =
        typeof payload === 'object' && Array.isArray((payload as { message?: unknown }).message)
          ? { errors: (payload as { message: unknown[] }).message }
          : undefined;

      const code: ErrorCode | string =
        status === 429
          ? 'RATE_LIMITED'
          : status === 401
            ? 'AUTH_TOKEN_INVALID'
            : status === 403
              ? 'FORBIDDEN'
              : status === 404
                ? 'TRIP_NOT_FOUND'
                : status === 409
                  ? 'IDEMPOTENCY_KEY_REUSED'
                  : 'VALIDATION_ERROR';

      return {
        success: false,
        error: { code, message, ...(details ? { details } : {}) },
        requestId,
      };
    }

    if (this.isDuplicateKeyError(exception)) {
      return {
        success: false,
        error: {
          code: 'ENTITY_ID_CONFLICT',
          message: 'A record with this identifier already exists',
        },
        requestId,
      };
    }

    return {
      success: false,
      error: { code: 'INTERNAL_ERROR', message: 'An unexpected error occurred' },
      requestId,
    };
  }

  private isDuplicateKeyError(exception: unknown): boolean {
    return (
      typeof exception === 'object' &&
      exception !== null &&
      (exception as { code?: number }).code === 11000
    );
  }
}
