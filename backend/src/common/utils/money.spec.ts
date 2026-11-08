import { MAX_AMOUNT_MINOR, MAX_EXPENSE_PARTICIPANTS } from '../constants';
import { AppError } from '../errors/app-error';
import {
  allocateEqualSplit,
  assertAmountMinor,
  assertNonNegativeMinor,
  sumMinor,
} from './money';

describe('allocateEqualSplit', () => {
  it('splits 1,000.00 equally among 4 members', () => {
    const splits = allocateEqualSplit(100_000, ['m4', 'm1', 'm3', 'm2'], 100);

    expect(splits).toEqual([
      { memberId: 'm1', amountMinor: 25_000 },
      { memberId: 'm2', amountMinor: 25_000 },
      { memberId: 'm3', amountMinor: 25_000 },
      { memberId: 'm4', amountMinor: 25_000 },
    ]);
  });

  it('assigns the paise remainder deterministically by sorted member id', () => {
    const splits = allocateEqualSplit(10_000, ['c', 'a', 'b'], 100);

    expect(splits).toEqual([
      { memberId: 'a', amountMinor: 3_334 },
      { memberId: 'b', amountMinor: 3_333 },
      { memberId: 'c', amountMinor: 3_333 },
    ]);
    expect(sumMinor(splits.map((split) => split.amountMinor))).toBe(10_000);
  });

  it('is stable across input ordering', () => {
    const first = allocateEqualSplit(999, ['x', 'y', 'z', 'w'], 100);
    const second = allocateEqualSplit(999, ['w', 'z', 'y', 'x'], 100);

    expect(second).toEqual(first);
  });

  it('rejects an empty participant list', () => {
    expect(() => allocateEqualSplit(100, [], 100)).toThrow(AppError);
  });

  it('rejects duplicate participants', () => {
    expect(() => allocateEqualSplit(100, ['a', 'a'], 100)).toThrow(AppError);
  });

  it('rejects more participants than the product limit', () => {
    const tooMany = Array.from(
      { length: MAX_EXPENSE_PARTICIPANTS + 1 },
      (_, index) => `member-${index}`,
    );

    expect(() => allocateEqualSplit(100, tooMany, MAX_EXPENSE_PARTICIPANTS)).toThrow(
      AppError,
    );
  });

  it('never loses or invents minor units for random amounts', () => {
    for (let run = 0; run < 500; run += 1) {
      const amount = 1 + Math.floor(Math.random() * MAX_AMOUNT_MINOR);
      const participantCount = 1 + Math.floor(Math.random() * 25);
      const participants = Array.from(
        { length: participantCount },
        (_, index) => `member-${index}`,
      );

      const splits = allocateEqualSplit(amount, participants, MAX_EXPENSE_PARTICIPANTS);

      expect(sumMinor(splits.map((split) => split.amountMinor))).toBe(amount);
      expect(new Set(splits.map((split) => split.memberId)).size).toBe(participantCount);
      expect(splits.every((split) => split.amountMinor >= 0)).toBe(true);
    }
  });
});

describe('amount validation', () => {
  it('accepts the maximum amount', () => {
    expect(assertAmountMinor(MAX_AMOUNT_MINOR)).toBe(MAX_AMOUNT_MINOR);
  });

  it.each([
    ['zero', 0],
    ['negative', -1],
    ['fractional', 1.5],
    ['above cap', MAX_AMOUNT_MINOR + 1],
    ['not a number', '100'],
    ['unsafe integer', Number.MAX_SAFE_INTEGER + 2],
  ])('rejects %s amount', (_label, amount) => {
    expect(() => assertAmountMinor(amount)).toThrow(AppError);
  });

  it('accepts zero only for non-negative values', () => {
    expect(assertNonNegativeMinor(0, 'amountMinor')).toBe(0);
    expect(() => assertNonNegativeMinor(-1, 'amountMinor')).toThrow(AppError);
  });
});
