import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/app_services.dart';
import '../../../core/database/app_database.dart';
import '../../../core/finance/balance_engine.dart';
import '../../../core/utils/money.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/feedback.dart';

class BalancesTab extends ConsumerWidget {
  const BalancesTab({super.key, required this.trip});

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
            return StreamBuilder<List<Settlement>>(
              stream: services.settlements.watchSettlements(trip.id),
              builder: (context, settlementSnapshot) {
                if (!expenseSnapshot.hasData || !settlementSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final expenses = expenseSnapshot.data!;
                final settlements = settlementSnapshot.data!;
                final balances = computeBalances(expenses, settlements);
                for (final member in members) {
                  balances.putIfAbsent(member.id, () => 0);
                }
                final reservation =
                    applyPendingReservations(balances, settlements);
                final suggestions = suggestTransfers(reservation.remaining);
                final myMemberId = _myMemberId(members, services.session.user?.id);

                return RefreshIndicator(
                  onRefresh: services.sync.syncNow,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 96),
                    children: [
                      _SectionHeader(
                        title: 'Balances',
                        subtitle: isBalanced(balances)
                            ? 'Everyone is settled up.'
                            : 'Confirmed expenses and payments.',
                      ),
                      if (balances.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Add expenses to see balances.'),
                        )
                      else
                        for (final entry in _sorted(balances))
                          _BalanceRow(
                            name: names[entry.key] ?? 'Unknown',
                            amountMinor: entry.value,
                            currency: trip.currency,
                            exponent: trip.currencyExponent,
                          ),
                      if (reservation.reservations.any((r) => r.appliedMinor > 0)) ...[
                        const _SectionHeader(
                          title: 'Pending reservations',
                          subtitle: 'Pending settlements do not change confirmed balances.',
                        ),
                        for (final pending in reservation.reservations)
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.hourglass_top),
                            title: Text(
                              '${names[pending.paidByMemberId] ?? 'Unknown'} → '
                              '${names[pending.paidToMemberId] ?? 'Unknown'}',
                            ),
                            subtitle: Text(
                              '${formatMoney(pending.amountMinor, trip.currency, trip.currencyExponent)} '
                              'pending (${formatMoney(pending.appliedMinor, trip.currency, trip.currencyExponent)} reserved)',
                            ),
                          ),
                      ],
                      _SectionHeader(
                        title: 'Suggested transfers',
                        subtitle: suggestions.isEmpty
                            ? 'No transfers needed.'
                            : 'Fewer payments to settle the group.',
                      ),
                      for (final suggestion in suggestions)
                        ListTile(
                          leading: const Icon(Icons.swap_horiz),
                          title: Text(
                            '${names[suggestion.fromMemberId] ?? 'Unknown'} pays '
                            '${names[suggestion.toMemberId] ?? 'Unknown'}',
                          ),
                          subtitle: Text(
                            formatMoney(
                              suggestion.amountMinor,
                              trip.currency,
                              trip.currencyExponent,
                            ),
                          ),
                          trailing: TextButton(
                            onPressed: trip.canWrite
                                ? () => _openSettlementDialog(
                                      context,
                                      ref,
                                      trip,
                                      members,
                                      from: suggestion.fromMemberId,
                                      to: suggestion.toMemberId,
                                      amountMinor: suggestion.amountMinor,
                                    )
                                : null,
                            child: const Text('Record'),
                          ),
                        ),
                      _SectionHeader(
                        title: 'Settlements',
                        subtitle: 'Recorded payments and their status.',
                        trailing: trip.canWrite
                            ? TextButton.icon(
                                onPressed: () => _openSettlementDialog(
                                  context,
                                  ref,
                                  trip,
                                  members,
                                ),
                                icon: const Icon(Icons.add),
                                label: const Text('Record payment'),
                              )
                            : null,
                      ),
                      if (settlements.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No settlements recorded yet.'),
                        )
                      else
                        for (final settlement in settlements)
                          _SettlementTile(
                            settlement: settlement,
                            fromName: names[settlement.paidByMemberId] ?? 'Unknown',
                            toName: names[settlement.paidToMemberId] ?? 'Unknown',
                            currency: trip.currency,
                            exponent: trip.currencyExponent,
                            canConfirm: trip.canWrite &&
                                settlement.isPending &&
                                _canRespond(
                                  settlement,
                                  myMemberId,
                                  members,
                                  trip.isAdmin,
                                ),
                            canCancel: trip.canWrite &&
                                (settlement.isPending || settlement.status == 'rejected') &&
                                _canCancel(settlement, myMemberId),
                            onConfirm: () => _transition(
                              context,
                              ref,
                              () => services.settlements.confirm(settlement),
                            ),
                            onReject: () => _reject(context, ref, settlement),
                            onCancel: () => _transition(
                              context,
                              ref,
                              () => services.settlements.cancel(settlement),
                            ),
                          ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String? _myMemberId(List<LocalMember> members, String? userId) {
    if (userId == null) return null;
    for (final member in members) {
      if (member.userId == userId) return member.id;
    }
    return null;
  }

  bool _canRespond(
    Settlement settlement,
    String? myMemberId,
    List<LocalMember> members,
    bool isAdmin,
  ) {
    if (myMemberId != null && settlement.paidToMemberId == myMemberId) {
      return true;
    }
    if (!isAdmin) return false;
    for (final member in members) {
      if (member.id == settlement.paidToMemberId && member.memberKind == 'guest') {
        return true;
      }
    }
    return false;
  }

  bool _canCancel(Settlement settlement, String? myMemberId) {
    if (myMemberId == null) return false;
    return settlement.paidByMemberId == myMemberId;
  }

  List<MapEntry<String, int>> _sorted(Map<String, int> balances) {
    final entries = balances.entries.toList()
      ..sort((a, b) {
        final byAmount = b.value.compareTo(a.value);
        return byAmount != 0 ? byAmount : a.key.compareTo(b.key);
      });
    return entries;
  }

  Future<void> _reject(
    BuildContext context,
    WidgetRef ref,
    Settlement settlement,
  ) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Reject payment'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Reason (optional)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
    if (reason == null || !context.mounted) return;
    await _transition(
      context,
      ref,
      () => ref
          .read(appServicesProvider)
          .settlements
          .reject(settlement, reason: reason),
    );
  }

  Future<void> _transition(
    BuildContext context,
    WidgetRef ref,
    Future<Settlement> Function() action,
  ) async {
    try {
      await action();
      if (context.mounted) showMessage(context, 'Settlement updated. It will sync shortly.');
    } catch (error) {
      if (context.mounted) showError(context, error);
    }
  }

  Future<void> _openSettlementDialog(
    BuildContext context,
    WidgetRef ref,
    LocalTrip trip,
    List<LocalMember> members, {
    String? from,
    String? to,
    int? amountMinor,
  }) async {
    final result = await showDialog<_SettlementInput>(
      context: context,
      builder: (context) => _SettlementDialog(
        trip: trip,
        members: members,
        from: from,
        to: to,
        amountMinor: amountMinor,
      ),
    );
    if (result == null || !context.mounted) return;
    try {
      await ref.read(appServicesProvider).settlements.create(
            tripId: trip.id,
            paidByMemberId: result.fromMemberId,
            paidToMemberId: result.toMemberId,
            amountMinor: result.amountMinor,
            paymentDate: result.paymentDate,
            note: result.note,
          );
      if (context.mounted) {
        showMessage(context, 'Payment recorded. It is waiting for confirmation.');
      }
    } catch (error) {
      if (context.mounted) showError(context, error);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 8, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                if (subtitle != null)
                  Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _BalanceRow extends StatelessWidget {
  const _BalanceRow({
    required this.name,
    required this.amountMinor,
    required this.currency,
    required this.exponent,
  });

  final String name;
  final int amountMinor;
  final String currency;
  final int exponent;

  @override
  Widget build(BuildContext context) {
    final positive = amountMinor > 0;
    final negative = amountMinor < 0;
    final color = positive
        ? Colors.green.shade700
        : negative
            ? Theme.of(context).colorScheme.error
            : null;
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 16,
        child: Text(name.isEmpty ? '?' : name.substring(0, 1).toUpperCase()),
      ),
      title: Text(name),
      trailing: Text(
        formatMoney(amountMinor, currency, exponent),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _SettlementTile extends StatelessWidget {
  const _SettlementTile({
    required this.settlement,
    required this.fromName,
    required this.toName,
    required this.currency,
    required this.exponent,
    required this.canConfirm,
    required this.canCancel,
    required this.onConfirm,
    required this.onReject,
    required this.onCancel,
  });

  final Settlement settlement;
  final String fromName;
  final String toName;
  final String currency;
  final int exponent;
  final bool canConfirm;
  final bool canCancel;
  final VoidCallback onConfirm;
  final VoidCallback onReject;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(settlement.paymentDate);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            Icon(
              settlement.isConfirmed
                  ? Icons.check_circle_outline
                  : settlement.isPending
                      ? Icons.schedule
                      : Icons.block,
              color: settlement.isConfirmed
                  ? Colors.green.shade700
                  : Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$fromName paid $toName'),
                  Text(
                    '${formatMoney(settlement.amountMinor, currency, exponent)}'
                    '${date == null ? '' : '  •  ${DateFormat('d MMM yyyy').format(date)}'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Wrap(
                    spacing: 6,
                    children: [
                      Chip(
                        label: Text(settlement.status),
                        visualDensity: VisualDensity.compact,
                      ),
                      if (settlement.hasPendingLocalChange)
                        const Chip(
                          label: Text('Pending sync'),
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (canConfirm || canCancel)
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'confirm':
                      onConfirm();
                    case 'reject':
                      onReject();
                    case 'cancel':
                      onCancel();
                  }
                },
                itemBuilder: (context) => [
                  if (canConfirm) ...[
                    const PopupMenuItem(value: 'confirm', child: Text('Confirm')),
                    const PopupMenuItem(value: 'reject', child: Text('Reject')),
                  ],
                  if (canCancel)
                    const PopupMenuItem(value: 'cancel', child: Text('Cancel payment')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _SettlementInput {
  const _SettlementInput({
    required this.fromMemberId,
    required this.toMemberId,
    required this.amountMinor,
    required this.paymentDate,
    required this.note,
  });

  final String fromMemberId;
  final String toMemberId;
  final int amountMinor;
  final String paymentDate;
  final String note;
}

class _SettlementDialog extends StatefulWidget {
  const _SettlementDialog({
    required this.trip,
    required this.members,
    this.from,
    this.to,
    this.amountMinor,
  });

  final LocalTrip trip;
  final List<LocalMember> members;
  final String? from;
  final String? to;
  final int? amountMinor;

  @override
  State<_SettlementDialog> createState() => _SettlementDialogState();
}

class _SettlementDialogState extends State<_SettlementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  final _date = TextEditingController();
  late String? _from;
  late String? _to;

  @override
  void initState() {
    super.initState();
    final active = widget.members
        .where((member) => member.status == 'active')
        .map((member) => member.id)
        .toList();
    _from = widget.from ?? (active.isEmpty ? null : active.first);
    String? defaultTo;
    for (final memberId in active) {
      if (memberId != _from) {
        defaultTo = memberId;
        break;
      }
    }
    _to = widget.to ?? defaultTo;
    _date.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (widget.amountMinor != null) {
      _amount.text = minorToMajorInput(
        widget.amountMinor!,
        widget.trip.currencyExponent,
      );
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    _date.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final current = DateTime.tryParse(_date.text) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _date.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = parseMajorToMinor(
      _amount.text,
      widget.trip.currencyExponent,
    );
    if (amount == null || amount <= 0) return;
    if (_from == null || _to == null || _from == _to) return;
    Navigator.pop(
      context,
      _SettlementInput(
        fromMemberId: _from!,
        toMemberId: _to!,
        amountMinor: amount,
        paymentDate: _date.text,
        note: _note.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Record payment'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _from,
                decoration: const InputDecoration(labelText: 'From'),
                items: [
                  for (final member in widget.members)
                    DropdownMenuItem(
                      value: member.id,
                      child: Text(member.displayName),
                    ),
                ],
                onChanged: (value) => setState(() => _from = value),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _to,
                decoration: const InputDecoration(labelText: 'To'),
                items: [
                  for (final member in widget.members)
                    if (member.id != _from)
                      DropdownMenuItem(
                        value: member.id,
                        child: Text(member.displayName),
                      ),
                ],
                onChanged: (value) => setState(() => _to = value),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amount,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: widget.trip.currency == 'INR' ? '₹ ' : null,
                ),
                validator: (value) {
                  final parsed = parseMajorToMinor(
                    value ?? '',
                    widget.trip.currencyExponent,
                  );
                  return parsed == null || parsed <= 0 ? 'Enter a valid amount' : null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _date,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(labelText: 'Payment date'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _note,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Record')),
      ],
    );
  }
}
