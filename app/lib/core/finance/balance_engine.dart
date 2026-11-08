import '../../shared/models/models.dart';

/// Local projection of the server balance rules (plan section 5).
Map<String, int> computeBalances(
  Iterable<Expense> expenses,
  Iterable<Settlement> settlements,
) {
  final balances = <String, int>{};
  void add(String memberId, int amount) {
    balances[memberId] = (balances[memberId] ?? 0) + amount;
  }

  for (final expense in expenses.where((expense) => !expense.isDeleted)) {
    add(expense.paidByMemberId, expense.amountMinor);
    for (final split in expense.splits) {
      add(split.memberId, -split.amountMinor);
    }
  }

  for (final settlement in settlements.where((entry) => entry.isConfirmed)) {
    add(settlement.paidByMemberId, settlement.amountMinor);
    add(settlement.paidToMemberId, -settlement.amountMinor);
  }

  return balances;
}

bool isBalanced(Map<String, int> balances) =>
    balances.values.fold<int>(0, (sum, value) => sum + value) == 0;

class ReservationResult {
  const ReservationResult({required this.remaining, required this.reservations});

  final Map<String, int> remaining;
  final List<PendingReservation> reservations;
}

/// Pending settlements are reservations: they reduce suggestions but not
/// confirmed balances.
ReservationResult applyPendingReservations(
  Map<String, int> confirmedBalances,
  Iterable<Settlement> settlements,
) {
  final remaining = Map<String, int>.from(confirmedBalances);
  final reservations = <PendingReservation>[];

  for (final settlement in settlements.where((entry) => entry.isPending)) {
    final sender = remaining[settlement.paidByMemberId] ?? 0;
    final receiver = remaining[settlement.paidToMemberId] ?? 0;
    final senderDebt = sender < 0 ? -sender : 0;
    final receiverCredit = receiver > 0 ? receiver : 0;
    final applied = <int>[
      settlement.amountMinor,
      senderDebt,
      receiverCredit,
    ].reduce((a, b) => a < b ? a : b);

    if (applied > 0) {
      remaining[settlement.paidByMemberId] = sender + applied;
      remaining[settlement.paidToMemberId] = receiver - applied;
    }
    reservations.add(
      PendingReservation(
        settlementId: settlement.id,
        paidByMemberId: settlement.paidByMemberId,
        paidToMemberId: settlement.paidToMemberId,
        amountMinor: settlement.amountMinor,
        appliedMinor: applied,
      ),
    );
  }

  return ReservationResult(remaining: remaining, reservations: reservations);
}

/// Greedy largest-debtor / largest-creditor matching with a deterministic
/// tie-break by member ID.
List<SettlementSuggestion> suggestTransfers(Map<String, int> remaining) {
  final creditors = remaining.entries
      .where((entry) => entry.value > 0)
      .map((entry) => _Amount(entry.key, entry.value))
      .toList()
    ..sort((a, b) {
      final byAmount = b.amount.compareTo(a.amount);
      return byAmount != 0 ? byAmount : a.memberId.compareTo(b.memberId);
    });
  final debtors = remaining.entries
      .where((entry) => entry.value < 0)
      .map((entry) => _Amount(entry.key, -entry.value))
      .toList()
    ..sort((a, b) {
      final byAmount = b.amount.compareTo(a.amount);
      return byAmount != 0 ? byAmount : a.memberId.compareTo(b.memberId);
    });

  final suggestions = <SettlementSuggestion>[];
  var creditorIndex = 0;
  var debtorIndex = 0;
  while (creditorIndex < creditors.length && debtorIndex < debtors.length) {
    final creditor = creditors[creditorIndex];
    final debtor = debtors[debtorIndex];
    final amount = creditor.amount < debtor.amount ? creditor.amount : debtor.amount;
    if (amount > 0) {
      suggestions.add(
        SettlementSuggestion(
          fromMemberId: debtor.memberId,
          toMemberId: creditor.memberId,
          amountMinor: amount,
        ),
      );
    }
    creditor.amount -= amount;
    debtor.amount -= amount;
    if (creditor.amount == 0) creditorIndex += 1;
    if (debtor.amount == 0) debtorIndex += 1;
  }
  return suggestions;
}

class _Amount {
  _Amount(this.memberId, this.amount);

  final String memberId;
  int amount;
}
