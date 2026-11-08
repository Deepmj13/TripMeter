import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_services.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/money.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/feedback.dart';

class ExpensesTab extends ConsumerWidget {
  const ExpensesTab({super.key, required this.trip});

  final LocalTrip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(appServicesProvider);
    return StreamBuilder<List<LocalMember>>(
      stream: services.members.watchMembers(trip.id),
      builder: (context, memberSnapshot) {
        final members = memberSnapshot.data ?? const <LocalMember>[];
        final names = {for (final member in members) member.id: member.displayName};
        return StreamBuilder<List<Expense>>(
          stream: services.expenses.watchExpenses(trip.id),
          builder: (context, expenseSnapshot) {
            if (expenseSnapshot.hasError) {
              return Center(child: Text('${expenseSnapshot.error}'));
            }
            if (!expenseSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final expenses = expenseSnapshot.data!;
            return Stack(
              children: [
                if (expenses.isEmpty)
                  const _EmptyExpenses()
                else
                  ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 96),
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return _ExpenseCard(
                        expense: expense,
                        currency: trip.currency,
                        exponent: trip.currencyExponent,
                        payerName: names[expense.paidByMemberId] ?? 'Unknown',
                        onTap: () => context.push(
                          '/trips/${trip.id}/expenses/${expense.id}',
                        ),
                        onDelete: () => _delete(context, ref, expense),
                      );
                    },
                  ),
                if (trip.canWrite)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton.extended(
                      onPressed: () => context.push('/trips/${trip.id}/expenses/new'),
                      icon: const Icon(Icons.add),
                      label: const Text('Add expense'),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Expense expense,
  ) async {
    final confirmed = await confirm(
      context,
      title: 'Delete expense?',
      message: 'The expense will be removed when the deletion syncs.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await ref.read(appServicesProvider).expenses.delete(expense);
    } catch (error) {
      if (context.mounted) showError(context, error);
    }
  }
}

class _ExpenseCard extends StatelessWidget {
  const _ExpenseCard({
    required this.expense,
    required this.currency,
    required this.exponent,
    required this.payerName,
    required this.onTap,
    required this.onDelete,
  });

  final Expense expense;
  final String currency;
  final int exponent;
  final String payerName;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateTime.tryParse(expense.expenseDate);
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.secondaryContainer,
                child: Icon(_categoryIcon(expense.category), size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            expense.title,
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          formatMoney(expense.amountMinor, currency, exponent),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Paid by $payerName'
                      '${date == null ? '' : '  •  ${DateFormat('d MMM yyyy').format(date)}'}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _Tag(label: expense.category),
                        _Tag(
                          label: expense.splitType == 'equal' ? 'Equal split' : 'Custom split',
                        ),
                        if (expense.hasPendingLocalChange)
                          _Tag(
                            label: expense.syncStatus == 'conflict'
                                ? 'Conflict'
                                : 'Pending sync',
                            color: theme.colorScheme.tertiaryContainer,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) => switch (category) {
        'food' => Icons.restaurant_outlined,
        'stay' => Icons.hotel_outlined,
        'transport' => Icons.directions_transit_outlined,
        'activities' => Icons.hiking_outlined,
        'shopping' => Icons.shopping_bag_outlined,
        _ => Icons.receipt_long_outlined,
      };
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

class _EmptyExpenses extends StatelessWidget {
  const _EmptyExpenses();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 64),
            const SizedBox(height: 12),
            Text(
              'No expenses yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Add the first shared cost. It is saved on this device immediately.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
