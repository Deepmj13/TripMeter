import {
  applyPendingReservations,
  BalanceExpense,
  BalanceSettlement,
  categoryTotals,
  computeBalances,
  isBalanced,
  suggestTransfers,
} from './balance-engine';

function expense(
  paidByMemberId: string,
  amountMinor: number,
  splits: Record<string, number>,
): BalanceExpense {
  return {
    paidByMemberId,
    amountMinor,
    splits: Object.entries(splits).map(([memberId, share]) => ({
      memberId,
      amountMinor: share,
    })),
  };
}

function settlement(
  paidByMemberId: string,
  paidToMemberId: string,
  amountMinor: number,
  status: BalanceSettlement['status'] = 'confirmed',
): BalanceSettlement {
  return { paidByMemberId, paidToMemberId, amountMinor, status };
}

function total(balances: Map<string, number>): number {
  return [...balances.values()].reduce((sum, value) => sum + value, 0);
}

describe('computeBalances', () => {
  it('credits the payer and debits each share', () => {
    const balances = computeBalances(
      [expense('owner', 50_000, { owner: 25_000, friend: 25_000 })],
      [],
    );

    expect(balances.get('owner')).toBe(25_000);
    expect(balances.get('friend')).toBe(-25_000);
    expect(isBalanced(balances)).toBe(true);
  });

  it('includes removed members through historical expenses', () => {
    const balances = computeBalances(
      [expense('owner', 30_000, { owner: 10_000, removed: 20_000 })],
      [],
    );

    expect(balances.get('removed')).toBe(-20_000);
  });

  it('ignores settlements that are not confirmed', () => {
    const balances = computeBalances(
      [expense('owner', 50_000, { owner: 25_000, friend: 25_000 })],
      [settlement('friend', 'owner', 10_000, 'pending')],
    );

    expect(balances.get('owner')).toBe(25_000);
    expect(balances.get('friend')).toBe(-25_000);
  });

  it('applies confirmed settlements to both parties', () => {
    const balances = computeBalances(
      [expense('owner', 50_000, { owner: 25_000, friend: 25_000 })],
      [settlement('friend', 'owner', 10_000)],
    );

    expect(balances.get('owner')).toBe(15_000);
    expect(balances.get('friend')).toBe(-15_000);
    expect(isBalanced(balances)).toBe(true);
  });

  it('keeps the zero-sum invariant for random trips', () => {
    for (let run = 0; run < 300; run += 1) {
      const memberCount = 2 + Math.floor(Math.random() * 8);
      const members = Array.from({ length: memberCount }, (_, index) => `m${index}`);
      const expenses: BalanceExpense[] = [];

      for (let e = 0; e < 1 + Math.floor(Math.random() * 10); e += 1) {
        const payer = members[Math.floor(Math.random() * memberCount)];
        const participants = members.filter(() => Math.random() > 0.25);
        if (participants.length === 0) participants.push(payer);
        const amount = 1 + Math.floor(Math.random() * 1_000_000);
        const base = Math.floor(amount / participants.length);
        const remainder = amount % participants.length;
        const splits: Record<string, number> = {};
        participants.forEach((memberId, index) => {
          splits[memberId] = base + (index < remainder ? 1 : 0);
        });
        expenses.push(expense(payer, amount, splits));
      }

      const confirmed = Array.from({ length: Math.floor(Math.random() * 4) }, () => {
        const from = members[Math.floor(Math.random() * memberCount)];
        let to = members[Math.floor(Math.random() * memberCount)];
        while (to === from) to = members[Math.floor(Math.random() * memberCount)];
        return settlement(from, to, 1 + Math.floor(Math.random() * 50_000));
      });

      const balances = computeBalances(expenses, confirmed);
      expect(total(balances)).toBe(0);
      expect(isBalanced(balances)).toBe(true);
    }
  });
});

describe('applyPendingReservations', () => {
  const balances = new Map<string, number>([
    ['owner', 25_000],
    ['friend', -25_000],
  ]);

  it('reserves pending settlements without changing confirmed balances', () => {
    const { remaining, reservations } = applyPendingReservations(balances, [
      settlement('friend', 'owner', 10_000, 'pending'),
    ]);

    expect(balances.get('owner')).toBe(25_000);
    expect(balances.get('friend')).toBe(-25_000);
    expect(remaining.get('owner')).toBe(15_000);
    expect(remaining.get('friend')).toBe(-15_000);
    expect(reservations).toEqual([
      {
        settlementId: null,
        paidByMemberId: 'friend',
        paidToMemberId: 'owner',
        amountMinor: 10_000,
        appliedMinor: 10_000,
      },
    ]);
  });

  it('caps a reservation at the sender debt and receiver credit', () => {
    const { remaining, reservations } = applyPendingReservations(
      new Map([
        ['owner', 5_000],
        ['friend', -25_000],
      ]),
      [settlement('friend', 'owner', 30_000, 'pending')],
    );

    expect(remaining.get('owner')).toBe(0);
    expect(remaining.get('friend')).toBe(-20_000);
    expect(reservations[0].appliedMinor).toBe(5_000);
    // The pending payment already covers the 5,000 credit, so it must not be
    // suggested again. The unmatched 20,000 has no creditor until confirmation.
    expect(suggestTransfers(remaining)).toEqual([]);
  });

  it('does not create a negative remaining debt', () => {
    const { remaining } = applyPendingReservations(
      new Map([
        ['owner', 2_000],
        ['friend', -1_000],
      ]),
      [settlement('friend', 'owner', 5_000, 'pending')],
    );

    for (const value of remaining.values()) {
      expect(Number.isFinite(value)).toBe(true);
    }
    expect(remaining.get('owner')).toBe(1_000);
    expect(remaining.get('friend')).toBe(0);

    // The pending payment of 5,000 already covers the 1,000 debt, so no
    // duplicate suggestion should be produced.
    const suggestions = suggestTransfers(remaining);
    expect(suggestions).toEqual([]);
    for (const suggestion of suggestions) {
      expect(suggestion.amountMinor).toBeGreaterThan(0);
    }
  });

  it('ignores confirmed, rejected and cancelled settlements', () => {
    const { remaining, reservations } = applyPendingReservations(balances, [
      settlement('friend', 'owner', 10_000, 'confirmed'),
      settlement('friend', 'owner', 10_000, 'rejected'),
      settlement('friend', 'owner', 10_000, 'cancelled'),
    ]);

    expect([...remaining.entries()]).toEqual([...balances.entries()]);
    expect(reservations).toEqual([]);
  });
});

describe('suggestTransfers', () => {
  it('matches largest debtors with largest creditors deterministically', () => {
    const suggestions = suggestTransfers(
      new Map([
        ['a', -7_000],
        ['b', -3_000],
        ['c', 6_000],
        ['d', 4_000],
      ]),
    );

    expect(suggestions).toEqual([
      { fromMemberId: 'a', toMemberId: 'c', amountMinor: 6_000 },
      { fromMemberId: 'a', toMemberId: 'd', amountMinor: 1_000 },
      { fromMemberId: 'b', toMemberId: 'd', amountMinor: 3_000 },
    ]);

    const settled = new Map<string, number>([
      ['a', -7_000],
      ['b', -3_000],
      ['c', 6_000],
      ['d', 4_000],
    ]);
    for (const suggestion of suggestions) {
      settled.set(suggestion.fromMemberId, settled.get(suggestion.fromMemberId)! + suggestion.amountMinor);
      settled.set(suggestion.toMemberId, settled.get(suggestion.toMemberId)! - suggestion.amountMinor);
    }
    expect([...settled.values()].every((value) => value === 0)).toBe(true);
  });

  it('returns no suggestions for balanced books', () => {
    expect(
      suggestTransfers(
        new Map([
          ['a', 0],
          ['b', 0],
        ]),
      ),
    ).toEqual([]);
  });
});

describe('categoryTotals', () => {
  it('sums active expense amounts per category', () => {
    type CategorizedExpense = BalanceExpense & { category: string };
    const expenses: CategorizedExpense[] = [
      { ...expense('a', 100, { a: 100 }), category: 'food' },
      { ...expense('a', 300, { a: 300 }), category: 'stay' },
      { ...expense('b', 200, { b: 200 }), category: 'food' },
    ];

    const totals = categoryTotals(expenses, (item) => (item as CategorizedExpense).category);

    expect(totals.get('food')).toBe(300);
    expect(totals.get('stay')).toBe(300);
  });
});
