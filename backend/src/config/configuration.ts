export interface AppConfiguration {
  nodeEnv: string;
  port: number;
  apiPrefix: string;
  appBaseUrl: string;
  corsOrigins: string[];
  mongodbUri: string;
  jwt: {
    accessSecret: string;
    accessTtl: string;
  };
  limits: {
    maxAmountMinor: number;
    maxExpenseParticipants: number;
    maxTripMembers: number;
    maxPageSize: number;
  };
}

export default (): AppConfiguration => ({
  nodeEnv: process.env.NODE_ENV ?? 'development',
  port: Number(process.env.PORT ?? 3000),
  apiPrefix: process.env.API_PREFIX ?? 'v1',
  appBaseUrl: process.env.APP_BASE_URL ?? 'http://localhost:3000',
  corsOrigins: (process.env.CORS_ORIGINS ?? '*')
    .split(',')
    .map((origin) => origin.trim())
    .filter(Boolean),
  mongodbUri: process.env.MONGODB_URI ?? 'mongodb://localhost:27017/tripmeter',
  jwt: {
    accessSecret: process.env.JWT_ACCESS_SECRET ?? 'development-only-secret-change-me',
    accessTtl: process.env.JWT_ACCESS_TTL ?? '15m',
  },
  limits: {
    maxAmountMinor: Number(process.env.MAX_AMOUNT_MINOR ?? 1_000_000_000_000),
    maxExpenseParticipants: Number(process.env.MAX_EXPENSE_PARTICIPANTS ?? 100),
    maxTripMembers: Number(process.env.MAX_TRIP_MEMBERS ?? 200),
    maxPageSize: Number(process.env.MAX_PAGE_SIZE ?? 100),
  },
});
