export type ErrorCode =
  | 'VALIDATION_ERROR'
  | 'AUTH_INVALID_CREDENTIALS'
  | 'AUTH_EMAIL_UNVERIFIED'
  | 'AUTH_TOKEN_EXPIRED'
  | 'AUTH_TOKEN_INVALID'
  | 'AUTH_REFRESH_REUSED'
  | 'FORBIDDEN'
  | 'TRIP_NOT_FOUND'
  | 'MEMBER_NOT_ELIGIBLE'
  | 'TRIP_ARCHIVED'
  | 'CURRENCY_IMMUTABLE'
  | 'EXPENSE_SPLIT_MISMATCH'
  | 'EXPENSE_VERSION_CONFLICT'
  | 'SETTLEMENT_INVALID_TRANSITION'
  | 'IDEMPOTENCY_KEY_REUSED'
  | 'EMAIL_IN_USE'
  | 'ENTITY_ID_CONFLICT'
  | 'INVITATION_INVALID'
  | 'PRECONDITION_REQUIRED'
  | 'CURSOR_EXPIRED'
  | 'RATE_LIMITED'
  | 'INTERNAL_ERROR';

export class AppError extends Error {
  constructor(
    public readonly code: ErrorCode,
    message: string,
    public readonly status: number,
    public readonly details?: Record<string, unknown>,
  ) {
    super(message);
    this.name = 'AppError';
  }

  static validation(message = 'The request is invalid', details?: Record<string, unknown>) {
    return new AppError('VALIDATION_ERROR', message, 400, details);
  }

  static forbidden(message = 'You are not allowed to perform this action') {
    return new AppError('FORBIDDEN', message, 403);
  }

  static notFound(code: ErrorCode = 'TRIP_NOT_FOUND', message = 'Resource not found') {
    return new AppError(code, message, 404);
  }

  static conflict(code: ErrorCode, message: string, details?: Record<string, unknown>) {
    return new AppError(code, message, 409, details);
  }
}
