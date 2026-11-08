import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_services.dart';
import '../../../shared/widgets/feedback.dart';

class TripFormScreen extends ConsumerStatefulWidget {
  const TripFormScreen({super.key, this.tripId});

  final String? tripId;

  @override
  ConsumerState<TripFormScreen> createState() => _TripFormScreenState();
}

class _TripFormScreenState extends ConsumerState<TripFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _destination = TextEditingController();
  final _description = TextEditingController();
  final _startDate = TextEditingController();
  final _endDate = TextEditingController();
  String _currency = 'INR';
  bool _loading = false;
  bool _busy = false;
  bool get _editing => widget.tripId != null;

  @override
  void initState() {
    super.initState();
    if (_editing) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final trip = await ref
        .read(appServicesProvider)
        .trips
        .localTrip(widget.tripId!);
    if (!mounted) return;
    if (trip != null) {
      _name.text = trip.name;
      _destination.text = trip.destination ?? '';
      _description.text = trip.description ?? '';
      _startDate.text = trip.startDate ?? '';
      _endDate.text = trip.endDate ?? '';
      _currency = trip.currency;
    }
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _name.dispose();
    _destination.dispose();
    _description.dispose();
    _startDate.dispose();
    _endDate.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final current = DateTime.tryParse(controller.text) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final services = ref.read(appServicesProvider);
      if (_editing) {
        await services.trips.update(
          widget.tripId!,
          name: _name.text,
          destination: _destination.text,
          description: _description.text,
          startDate: _startDate.text,
          endDate: _endDate.text,
        );
      } else {
        final trip = await services.trips.create(
          name: _name.text,
          destination: _destination.text,
          description: _description.text,
          startDate: _startDate.text,
          endDate: _endDate.text,
          currency: _currency,
        );
        if (mounted) {
          context.pushReplacement('/trips/${trip.id}');
          return;
        }
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
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? 'Edit trip' : 'New trip')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: _name,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Trip name',
                        prefixIcon: Icon(Icons.luggage_outlined),
                      ),
                      validator: (value) => (value ?? '').trim().isEmpty
                          ? 'Give the trip a name'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _destination,
                      decoration: const InputDecoration(
                        labelText: 'Destination (optional)',
                        prefixIcon: Icon(Icons.place_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _description,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _startDate,
                            readOnly: true,
                            onTap: () => _pickDate(_startDate),
                            decoration: const InputDecoration(
                              labelText: 'Start date',
                              prefixIcon: Icon(Icons.event_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _endDate,
                            readOnly: true,
                            onTap: () => _pickDate(_endDate),
                            decoration: const InputDecoration(
                              labelText: 'End date',
                              prefixIcon: Icon(Icons.event_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _currency,
                      decoration: const InputDecoration(
                        labelText: 'Currency',
                        prefixIcon: Icon(Icons.payments_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'INR', child: Text('INR (rupee)')),
                      ],
                      onChanged: _editing
                          ? null
                          : (value) => setState(() => _currency = value ?? 'INR'),
                    ),
                    if (_editing) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Currency cannot change after the trip starts recording expenses.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _busy ? null : _submit,
                      child: _busy
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_editing ? 'Save changes' : 'Create trip'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
