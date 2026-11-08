import 'package:flutter_test/flutter_test.dart';
import 'package:tripmeter/core/finance/balance_engine.dart';
import 'package:tripmeter/shared/models/models.dart';

Expense expense({
  required String id,
  required String paidBy,
  required int amount,
  required Map<String, int> splits,
  String status = 'active',
}) {
  return Expense(
    id: id,
    tripId: 'trip',
    title: id,
    amountMinor: amount,
    currency: 'INR',
    paidByMemberId: paidBy,
    createdByUserId: 'u1',
    splitType: 'equal',
    splits: splits.entries
        .map((entry) => ExpenseSplit(memberId: entry.key, amountMinor: entry.value))
        .toList(),
    expenseDate: '2026-01-01',
    category: 'other',
    status: status,
    version: 1,
  );
}

Settlement settlement({
  required String id,
  required String from,
  required String to,
  required int amount,
  String status = 'confirmed',
}) {
  return Settlement(
    id: id,
    tripId: 'trip',
    paidByMemberId: from,
    paidToMemberId: to,
    amountMinor: amount,
    paymentDate: '2026-01-01',
    status: status,
    recordedByUserId: 'u1',
    version: 1,
  );
}

void main() {
  group('computeBalances', () {
    test('a payer is credited and participants are debited', () {
      final balances = computeBalances(
        [
          expense(
            id: 'e1',
            paidBy: 'a',
            amount: 1000,
            splits: {'a': 250, 'b': 250, 'c': 250, 'd': 250},
          ),
        ],
        const [],
      );

      expect(balances['a'], 750);
      expect(balances['b'], -250);
      expect(balances['c'], -250);
      expect(balances['d'], -250);
      expect(isBalanced(balances), isTrue);
    });

    test('deleted expenses and unconfirmed settlements are ignored', () {
      final balances = computeBalances(
        [
          expense(
            id: 'active',
            paidBy: 'a',
            amount: 300,
            splits: {'a': 150, 'b': 150},
          ),
          expense(
            id: 'deleted',
            paidBy: 'a',
            amount: 5000,
            splits: {'a': 2500, 'b': 2500},
            status: 'deleted',
          ),
        ],
        [
          settlement(id: 's1', from: 'b', to: 'a', amount: 50),
          settlement(id: 's2', from: 'b', to: 'a', amount: 50, status: 'pending'),
          settlement(id: 's3', from: 'b', to: 'a', amount: 50, status: 'rejected'),
        ],
      );

      expect(balances['a'], 100);
      expect(balances['b'], -100);
      expect(isBalanced(balances), isTrue);
    });
  });

  group('pending reservations', () {
    test('pending settlements reduce suggestions without changing balances', () {
      const balances = {'a': 1000, 'b': -1000};
      final result = applyPendingReservations(balances, [
        settlement(id: 's1', from: 'b', to: 'a', amount: 400, status: 'pending'),
      ]);

      expect(balances, {'a': 1000, 'b': -1000});
      expect(result.remaining['a'], 600);
      expect(result.remaining['b'], -600);
      expect(result.reservations.single.appliedMinor, 400);
    });

    test('reservations are capped by the outstanding amounts', () {
      const balances = {'a': 100, 'b': -100, 'c': 0};
      final result = applyPendingReservations(balances, [
        settlement(id: 's1', from: 'b', to: 'a', amount: 500, status: 'pending'),
      ]);

      expect(result.reservations.single.appliedMinor, 100);
      expect(result.remaining['a'], 0);
      expect(result.remaining['b'], 0);
    });

    test('a reservation in the wrong direction applies nothing', () {
      const balances = {'a': 1000, 'b': -1000};
      final result = applyPendingReservations(balances, [
        settlement(id: 's1', from: 'a', to: 'b', amount: 500, status: 'pending'),
      ]);

      expect(result.reservations.single.appliedMinor, 0);
      expect(result.remaining, balances);
    });
  });

  group('suggestTransfers', () {
    test('matches largest debtors with largest creditors deterministically', () {
      final suggestions = suggestTransfers({
        'a': 700,
        'b': 300,
        'c': -600,
        'd': -400,
      });

      expect(suggestions.length, 3);
      expect(suggestions[0].fromMemberId, 'c');
      expect(suggestions[0].toMemberId, 'a');
      expect(suggestions[0].amountMinor, 600);
      expect(suggestions[1].fromMemberId, 'd');
      expect(suggestions[1].toMemberId, 'a');
      expect(suggestions[1].amountMinor, 100);
      expect(suggestions[2].fromMemberId, 'd');
      expect(suggestions[2].toMemberId, 'b');
      expect(suggestions[2].amountMinor, 300);
      expect(
        suggestions.fold<int>(0, (sum, item) => sum + item.amountMinor),
        1000,
      );
    });

    test('produces no transfers for balanced books', () {
      expect(suggestTransfers({'a': 0, 'b': 0}), isEmpty);
    });
  });
}
