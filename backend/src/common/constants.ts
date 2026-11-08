/**
 * Fixed product limits. The plan requires these to be constants shared by
 * every endpoint rather than per-screen values.
 */
export const MAX_AMOUNT_MINOR = 1_000_000_000_000;
export const MAX_EXPENSE_PARTICIPANTS = 100;
export const MAX_TRIP_MEMBERS = 200;
export const MAX_PAGE_SIZE = 100;
export const SYNC_BATCH_SIZE = 100;

export const ACCESS_TOKEN_TTL = process.env.JWT_ACCESS_TTL ?? '15m';
export const REFRESH_TOKEN_TTL_DAYS = Number(process.env.REFRESH_TOKEN_TTL_DAYS ?? 30);
export const EMAIL_VERIFICATION_TTL_HOURS = Number(process.env.EMAIL_VERIFICATION_TTL_HOURS ?? 24);
export const PASSWORD_RESET_TTL_MINUTES = Number(process.env.PASSWORD_RESET_TTL_MINUTES ?? 30);
export const INVITATION_TTL_DAYS = Number(process.env.INVITATION_TTL_DAYS ?? 7);
export const IDEMPOTENCY_RETENTION_DAYS = Number(process.env.IDEMPOTENCY_RETENTION_DAYS ?? 30);
export const EVENT_RETENTION_DAYS = Number(process.env.EVENT_RETENTION_DAYS ?? 90);
export const EVENT_RETENTION_COUNT = Number(process.env.EVENT_RETENTION_COUNT ?? 100_000);
export const OUTBOX_MAX_AUTOMATIC_ATTEMPTS = Number(process.env.OUTBOX_MAX_AUTOMATIC_ATTEMPTS ?? 8);

export const EXPENSE_CATEGORIES = [
  'food',
  'stay',
  'transport',
  'activities',
  'shopping',
  'other',
] as const;

export type ExpenseCategory = (typeof EXPENSE_CATEGORIES)[number];

export const SPLIT_TYPES = ['equal', 'custom'] as const;
export type SplitType = (typeof SPLIT_TYPES)[number];

export const MEMBER_KINDS = ['account', 'guest'] as const;
export type MemberKind = (typeof MEMBER_KINDS)[number];

export const MEMBER_ROLES = ['owner', 'admin', 'member'] as const;
export type MemberRole = (typeof MEMBER_ROLES)[number];

export const MEMBER_STATUSES = ['invited', 'active', 'left', 'removed'] as const;
export type MemberStatus = (typeof MEMBER_STATUSES)[number];

export const SETTLEMENT_STATUSES = ['pending', 'confirmed', 'rejected', 'cancelled'] as const;
export type SettlementStatus = (typeof SETTLEMENT_STATUSES)[number];

export const EVENT_TYPES = [
  'trip.created',
  'trip.updated',
  'member.added',
  'member.updated',
  'member.removed',
  'expense.created',
  'expense.updated',
  'expense.deleted',
  'settlement.created',
  'settlement.updated',
] as const;

export const USER_EVENT_TYPES = [
  'trip.access.granted',
  'trip.access.revoked',
  'trip.membership.changed',
  'invitation.created',
  'invitation.updated',
  'account.deleted',
] as const;

export const SUPPORTED_CURRENCIES: Record<string, number> = {
  INR: 2,
};
