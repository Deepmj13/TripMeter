const REQUIRED_IN_PRODUCTION = ['MONGODB_URI', 'JWT_ACCESS_SECRET', 'APP_BASE_URL'];

export function validateEnvironment(config: Record<string, unknown>): Record<string, unknown> {
  const nodeEnv = String(config.NODE_ENV ?? 'development');

  if (nodeEnv === 'production') {
    const missing = REQUIRED_IN_PRODUCTION.filter((key) => !config[key] || config[key] === '');
    if (missing.length > 0) {
      throw new Error(`Missing required environment variables: ${missing.join(', ')}`);
    }
    if (String(config.JWT_ACCESS_SECRET).length < 32) {
      throw new Error('JWT_ACCESS_SECRET must be at least 32 characters in production');
    }
  }

  const numericKeys = [
    'PORT',
    'REFRESH_TOKEN_TTL_DAYS',
    'PASSWORD_RESET_TTL_MINUTES',
    'INVITATION_TTL_DAYS',
    'IDEMPOTENCY_RETENTION_DAYS',
    'EVENT_RETENTION_DAYS',
    'EVENT_RETENTION_COUNT',
    'MAX_AMOUNT_MINOR',
    'MAX_EXPENSE_PARTICIPANTS',
    'MAX_TRIP_MEMBERS',
    'MAX_PAGE_SIZE',
    'OUTBOX_MAX_AUTOMATIC_ATTEMPTS',
  ];

  for (const key of numericKeys) {
    if (config[key] === undefined || config[key] === '') continue;
    const value = Number(config[key]);
    if (!Number.isFinite(value) || value <= 0) {
      throw new Error(`${key} must be a positive number`);
    }
    config[key] = value;
  }

  return config;
}
