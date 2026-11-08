import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/app_services.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/money.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/feedback.dart';

const _categories = ['food', 'stay', 'transport', 'activities', 'shopping', 'other'];

class ExpenseFormScreen extends ConsumerStatefulWidget {
  const ExpenseFormScreen({
    super.key,
    required this.tripId,
    this.expenseId,
  });

  final String tripId;
  final String? expenseId;

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _amount = TextEditingController();
  final _description = TextEditingController();
  final _date = TextEditingController();
  final _customControllers = <String, TextEditingController>{};

  LocalTrip? _trip;
  List<LocalMember> _members = const [];
  String? _payerMemberId;
  String _splitType = 'equal';
  final _participants = <String>{};
  String _category = 'other';
  bool _loading = true;
  bool _busy = false;
  Expense? _existing;

  bool get _editing => widget.expenseId != null;

  @override
  void initState() {
    super.initState();
    _date.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _load();
  }

  Future<void> _load() async {
    final services = ref.read(appServicesProvider);
    final trip = await services.trips.localTrip(widget.tripId);
    final members = await services.members.members(widget.tripId);
    Expense? expense;
    if (_editing) expense = await services.expenses.get(widget.expenseId!);

    if (!mounted) return;
    _trip = trip;
    _members = members;
    _existing = expense;

    if (expense != null) {
      _title.text = expense.title;
      _amount.text = minorToMajorInput(
        expense.amountMinor,
        trip?.currencyExponent ?? 2,
      );
      _description.text = expense.description;
      _date.text = expense.expenseDate;
      _payerMemberId = expense.paidByMemberId;
      _splitType = expense.splitType;
      _category = expense.category;
      _participants
        ..clear()
        ..addAll(expense.splits.map((split) => split.memberId));
      for (final split in expense.splits) {
        _customControllers[split.memberId] = TextEditingController(
          text: minorToMajorInput(split.amountMinor, trip?.currencyExponent ?? 2),
        );
      }
    } else {
      final active = members.where((member) => member.status == 'active').toList();
      _payerMemberId = trip?.memberId ??
          (active.isNotEmpty ? active.first.id : null);
      _participants.addAll(active.map((member) => member.id));
    }
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    _description.dispose();
    _date.dispose();
    for (final controller in _customControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  int get _exponent => _trip?.currencyExponent ?? 2;

  int? get _amountMinor => parseMajorToMinor(_amount.text, _exponent);

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

  Map<String, int> _customSplits() {
    final splits = <String, int>{};
    for (final memberId in _participants) {
      final value = parseMajorToMinor(
        _customControllers[memberId]?.text ?? '',
        _exponent,
      );
      if (value != null) splits[memberId] = value;
    }
    return splits;
  }

  void _changeSplitType(String value) {
    setState(() {
      _splitType = value;
      if (value == 'custom') {
        final amount = _amountMinor;
        if (amount != null && _participants.isNotEmpty) {
          final allocation = allocateEqualSplit(amount, _participants);
          for (final entry in allocation.entries) {
            _customControllers.putIfAbsent(
              entry.key,
              () => TextEditingController(),
            );
            _customControllers[entry.key]!.text =
                minorToMajorInput(entry.value, _exponent);
          }
        }
      }
    });
  }

  void _toggleParticipant(String memberId, bool selected) {
    setState(() {
      if (selected) {
        _participants.add(memberId);
        _customControllers.putIfAbsent(
          memberId,
          () => TextEditingController(),
        );
      } else {
        _participants.remove(memberId);
        _customControllers.remove(memberId)?.dispose();
      }
    });
  }

  Future<void> _submit() async {
    final trip = _trip;
    if (trip == null) return;
    if (!_formKey.currentState!.validate()) return;
    final amountMinor = _amountMinor;
    if (amountMinor == null || amountMinor <= 0) {
      showMessage(context, 'Enter a valid amount.');
      return;
    }
    if (_payerMemberId == null) {
      showMessage(context, 'Choose who paid.');
      return;
    }
    if (_participants.isEmpty) {
      showMessage(context, 'Choose at least one person to split with.');
      return;
    }
    final custom = _customSplits();
    if (_splitType == 'custom') {
      final total = custom.values.fold<int>(0, (sum, value) => sum + value);
      if (total != amountMinor) {
        showMessage(
          context,
          'Custom splits add up to ${formatMoney(total, trip.currency, _exponent)}, '
          'but the expense is ${formatMoney(amountMinor, trip.currency, _exponent)}.',
        );
        return;
      }
    }

    setState(() => _busy = true);
    try {
      final repo = ref.read(appServicesProvider).expenses;
      if (_existing == null) {
        await repo.create(
          tripId: trip.id,
          title: _title.text,
          amountMinor: amountMinor,
          currency: trip.currency,
          paidByMemberId: _payerMemberId!,
          splitType: _splitType,
          participantMemberIds: _participants.toList(),
          customSplits: custom,
          expenseDate: _date.text,
          category: _category,
          description: _description.text,
        );
      } else {
        await repo.update(
          existing: _existing!,
          title: _title.text,
          amountMinor: amountMinor,
          paidByMemberId: _payerMemberId!,
          splitType: _splitType,
          participantMemberIds: _participants.toList(),
          customSplits: custom,
          expenseDate: _date.text,
          category: _category,
          description: _description.text,
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) showError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final trip = _trip;
    if (trip == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Expense')),
        body: const Center(child: Text('Trip not found on this device.')),
      );
    }
    final currency = trip.currency;
    final customTotal = _customSplits().values.fold<int>(0, (sum, value) => sum + value);
    final remaining = (_amountMinor ?? 0) - customTotal;

    return Scaffold(
      appBar: AppBar(title: Text(_editing ? 'Edit expense' : 'New expense')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _title,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'What was it for?',
                  prefixIcon: Icon(Icons.receipt_long_outlined),
                ),
                validator: (value) =>
                    (value ?? '').trim().isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amount,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,₹]')),
                ],
                decoration: InputDecoration(
                  labelText: 'Amount ($currency)',
                  prefixText: currency == 'INR' ? '₹ ' : '$currency ',
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  final parsed = parseMajorToMinor(value ?? '', _exponent);
                  if (parsed == null || parsed <= 0) return 'Enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _payerMemberId,
                decoration: const InputDecoration(
                  labelText: 'Paid by',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: [
                  for (final member in _members)
                    DropdownMenuItem(
                      value: member.id,
                      child: Text(
                        '${member.displayName}${member.status == 'active' ? '' : ' (${member.status})'}',
                      ),
                    ),
                ],
                onChanged: (value) => setState(() => _payerMemberId = value),
                validator: (value) => value == null ? 'Choose who paid' : null,
              ),
              const SizedBox(height: 16),
              Text('Split', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'equal', label: Text('Equal')),
                  ButtonSegment(value: 'custom', label: Text('Custom')),
                ],
                selected: {_splitType},
                onSelectionChanged: (value) => _changeSplitType(value.first),
              ),
              const SizedBox(height: 8),
              if (_splitType == 'equal')
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final member in _members)
                      FilterChip(
                        label: Text(member.displayName),
                        selected: _participants.contains(member.id),
                        onSelected: (selected) =>
                            _toggleParticipant(member.id, selected),
                      ),
                  ],
                )
              else ...[
                for (final member in _members)
                  _CustomSplitRow(
                    member: member,
                    selected: _participants.contains(member.id),
                    controller: _customControllers[member.id],
                    currency: currency,
                    onToggle: (selected) =>
                        _toggleParticipant(member.id, selected),
                    onChanged: () => setState(() {}),
                  ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Remaining: ${formatMoney(remaining, currency, _exponent)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: remaining == 0
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                        ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _date,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: 'Expense date',
                  prefixIcon: Icon(Icons.event_outlined),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: [
                  for (final category in _categories)
                    DropdownMenuItem(value: category, child: Text(category)),
                ],
                onChanged: (value) => setState(() => _category = value ?? 'other'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _busy || !trip.canWrite ? null : _submit,
                child: _busy
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_editing ? 'Save changes' : 'Add expense'),
              ),
              if (!trip.canWrite)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'This trip is archived.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomSplitRow extends StatelessWidget {
  const _CustomSplitRow({
    required this.member,
    required this.selected,
    required this.controller,
    required this.currency,
    required this.onToggle,
    required this.onChanged,
  });

  final LocalMember member;
  final bool selected;
  final TextEditingController? controller;
  final String currency;
  final ValueChanged<bool> onToggle;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(member.displayName),
            value: selected,
            onChanged: (value) => onToggle(value ?? false),
          ),
        ),
        if (selected)
          SizedBox(
            width: 120,
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                isDense: true,
                prefixText: currency == 'INR' ? '₹' : null,
                hintText: '0',
              ),
              onChanged: (_) => onChanged(),
            ),
          ),
      ],
    );
  }
}
