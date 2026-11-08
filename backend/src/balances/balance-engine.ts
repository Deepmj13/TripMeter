export interface BalanceExpense {
  paidByMemberId: string;
  amountMinor: number;
  splits: { memberId: string; amountMinor: number }[];
}

export interface BalanceSettlement {
  _id?: string;
  paidByMemberId: string;
  paidToMemberId: string;
  amountMinor: number;
  status: 'pending' | 'confirmed' | 'rejected' | 'cancelled';
}

export interface SuggestedTransfer {
  fromMemberId: string;
  toMemberId: string;
  amountMinor: number;
}

export interface PendingReservation {
  settlementId: string | null;
  paidByMemberId: string;
  paidToMemberId: string;
  amountMinor: number;
  appliedMinor: number;
}

/**
 * net = expenses paid - expense shares + confirmed settlements paid
 *       - confirmed settlements received (plan §5.2).
 * Only active expenses and confirmed settlements are passed in.
 */
export function computeBalances(
  expenses: BalanceExpense[],
  confirmedSettlements: BalanceSettlement[],
): Map<string, number> {
  const balances = new Map<string, number>();
  const add = (memberId: string, amount: number) => {
    balances.set(memberId, (balances.get(memberId) ?? 0) + amount);
  };

  for (const expense of expenses) {
    add(expense.paidByMemberId, expense.amountMinor);
    for (const split of expense.splits) {
      add(split.memberId, -split.amountMinor);
    }
  }

  for (const settlement of confirmedSettlements) {
    if (settlement.status !== 'confirmed') continue;
    add(settlement.paidByMemberId, settlement.amountMinor);
    add(settlement.paidToMemberId, -settlement.amountMinor);
  }

  return balances;
}

export function isBalanced(balances: Map<string, number>): boolean {
  let sum = 0;
  for (const value of balances.values()) sum += value;
  return sum === 0;
}

/**
 * Applies pending settlements as reservations so suggestions do not ask for a
 * payment already in flight. Confirmed balances are not changed (§5.5).
 */
export function applyPendingReservations(
  confirmedBalances: Map<string, number>,
  pendingSettlements: BalanceSettlement[],
): { remaining: Map<string, number>; reservations: PendingReservation[] } {
  const remaining = new Map(confirmedBalances);
  const reservations: PendingReservation[] = [];

  for (const settlement of pendingSettlements) {
    if (settlement.status !== 'pending') continue;
    const sender = remaining.get(settlement.paidByMemberId) ?? 0;
    const receiver = remaining.get(settlement.paidToMemberId) ?? 0;
    const senderDebt = Math.max(0, -sender);
    const receiverCredit = Math.max(0, receiver);
    const appliedMinor = Math.min(settlement.amountMinor, senderDebt, receiverCredit);

    if (appliedMinor > 0) {
      remaining.set(settlement.paidByMemberId, sender + appliedMinor);
      remaining.set(settlement.paidToMemberId, receiver - appliedMinor);
    }

    reservations.push({
      settlementId: settlement._id ?? null,
      paidByMemberId: settlement.paidByMemberId,
      paidToMemberId: settlement.paidToMemberId,
      amountMinor: settlement.amountMinor,
      appliedMinor,
    });
  }

  return { remaining, reservations };
}

/**
 * Greedy largest-debtor / largest-creditor matching (§5.5). Deterministic tie
 * break by member ID.
 */
export function suggestTransfers(remaining: Map<string, number>): SuggestedTransfer[] {
  const creditors = [...remaining.entries()]
    .filter(([, amount]) => amount > 0)
    .map(([memberId, amount]) => ({ memberId, amount }))
    .sort((a, b) => b.amount - a.amount || a.memberId.localeCompare(b.memberId));

  const debtors = [...remaining.entries()]
    .filter(([, amount]) => amount < 0)
    .map(([memberId, amount]) => ({ memberId, amount: -amount }))
    .sort((a, b) => b.amount - a.amount || a.memberId.localeCompare(b.memberId));

  const suggestions: SuggestedTransfer[] = [];
  let ci = 0;
  let di = 0;

  while (ci < creditors.length && di < debtors.length) {
    const amountMinor = Math.min(creditors[ci].amount, debtors[di].amount);
    if (amountMinor > 0) {
      suggestions.push({
        fromMemberId: debtors[di].memberId,
        toMemberId: creditors[ci].memberId,
        amountMinor,
      });
    }
    creditors[ci].amount -= amountMinor;
    debtors[di].amount -= amountMinor;
    if (creditors[ci].amount === 0) ci += 1;
    if (debtors[di].amount === 0) di += 1;
  }

  return suggestions;
}

export function categoryTotals(
  expenses: BalanceExpense[],
  categoryOf: (expense: BalanceExpense) => string,
): Map<string, number> {
  const totals = new Map<string, number>();
  for (const expense of expenses) {
    const category = categoryOf(expense);
    totals.set(category, (totals.get(category) ?? 0) + expense.amountMinor);
  }
  return totals;
}
