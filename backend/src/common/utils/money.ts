import { MAX_AMOUNT_MINOR } from '../constants';
import { AppError } from '../errors/app-error';

export function assertAmountMinor(value: unknown, field = 'amountMinor'): number {
  if (
    typeof value !== 'number' ||
    !Number.isSafeInteger(value) ||
    value <= 0 ||
    value > MAX_AMOUNT_MINOR
  ) {
    throw AppError.validation(`${field} must be a positive safe integer within the allowed range`, {
      field,
      max: MAX_AMOUNT_MINOR,
    });
  }
  return value;
}

export function assertNonNegativeMinor(value: unknown, field: string): number {
  if (
    typeof value !== 'number' ||
    !Number.isSafeInteger(value) ||
    value < 0 ||
    value > MAX_AMOUNT_MINOR
  ) {
    throw AppError.validation(`${field} must be a non-negative safe integer within the allowed range`, {
      field,
      max: MAX_AMOUNT_MINOR,
    });
  }
  return value;
}

export interface SplitAllocation {
  memberId: string;
  amountMinor: number;
}

/**
 * Deterministic equal split (plan §5.3). Members are sorted by UUID so a retry
 * always produces identical allocations and the exact total is preserved.
 */
export function allocateEqualSplit(
  amountMinor: number,
  memberIds: string[],
  maxParticipants: number,
): SplitAllocation[] {
  if (memberIds.length === 0) {
    throw AppError.validation('At least one split participant is required');
  }
  if (memberIds.length > maxParticipants) {
    throw AppError.validation(`An expense may have at most ${maxParticipants} participants`, {
      maxParticipants,
    });
  }
  if (new Set(memberIds).size !== memberIds.length) {
    throw AppError.validation('Duplicate split participants are not allowed');
  }

  const ordered = [...memberIds].sort();
  const base = Math.floor(amountMinor / ordered.length);
  const remainder = amountMinor % ordered.length;

  return ordered.map((memberId, index) => ({
    memberId,
    amountMinor: base + (index < remainder ? 1 : 0),
  }));
}

export function sumMinor(values: number[]): number {
  const total = values.reduce((sum, value) => sum + value, 0);
  if (!Number.isSafeInteger(total)) {
    throw AppError.validation('The monetary total exceeds the safe integer range');
  }
  return total;
}
