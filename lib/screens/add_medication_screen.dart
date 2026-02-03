import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/medication.dart';
import '../providers/app_provider.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _doseController = TextEditingController();
  final _refillsController = TextEditingController(text: '3');
  final _pharmacyController = TextEditingController(text: 'CVS Pharmacy - Main St');

  String _frequency = 'Once daily';
  final List<TimeOfDay> _times = <TimeOfDay>[const TimeOfDay(hour: 9, minute: 0)];

  static const List<String> _frequencyOptions = <String>[
    'Once daily',
    'Twice daily',
    'Three times daily',
    'Every 4 hours',
    'Every 6 hours',
    'Every 8 hours',
    'Every 12 hours',
    'As needed',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    _refillsController.dispose();
    _pharmacyController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _nameController.text.trim().isNotEmpty &&
          _doseController.text.trim().isNotEmpty &&
          _times.isNotEmpty;

  List<String> _timesAsStrings() {
    return _times
        .map((t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}')
        .toList(growable: false);
  }

  Future<void> _pickTime(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _times[index],
    );
    if (picked == null) return;

    setState(() => _times[index] = picked);
  }

  void _addTime() {
    setState(() => _times.add(const TimeOfDay(hour: 12, minute: 0)));
  }

  void _removeTime(int index) {
    if (_times.length <= 1) return;
    setState(() => _times.removeAt(index));
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || !_canSubmit) return;

    final refills = int.tryParse(_refillsController.text.trim()) ?? 0;

    final med = Medication(
      id: 'temp', // AppProvider.addMedication() will replace it
      name: _nameController.text.trim(),
      dose: _doseController.text.trim(),
      frequency: _frequency,
      times: _timesAsStrings(),
      refillsRemaining: refills < 0 ? 0 : refills,
      pharmacy: _pharmacyController.text.trim(),
      history: const [],
    );

    context.read<AppProvider>().addMedication(med);
    context.go('/medications');
  }

  @override
  Widget build(BuildContext context) {
    final leftHandMode = context.watch<AppProvider>().leftHandMode;

    final colorScheme = Theme.of(context).colorScheme;

    final inputTheme = Theme.of(context).inputDecorationTheme.copyWith(
      filled: true,
      fillColor: colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
    );

    final backButton = IconButton(
      tooltip: 'Back',
      onPressed: () => context.go('/medications'),
      icon: const Icon(Icons.arrow_back),
    );

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Add Medication'),
        centerTitle: false,
        leading: leftHandMode ? null : backButton,
        actions: leftHandMode ? <Widget>[backButton] : const <Widget>[],
      ),
      body: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(inputDecorationTheme: inputTheme),
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                  children: [
                    _CardSection(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LabeledField(
                            label: 'Medication Name *',
                            child: TextFormField(
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                hintText: 'e.g., Lisinopril',
                              ),
                              validator: (v) =>
                              (v == null || v.trim().isEmpty) ? 'Medication name is required' : null,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _LabeledField(
                            label: 'Dose *',
                            child: TextFormField(
                              controller: _doseController,
                              textInputAction: TextInputAction.next,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                hintText: 'e.g., 10mg, 2 tablets',
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Dose is required' : null,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _LabeledField(
                            label: 'Frequency',
                            child: DropdownButtonFormField<String>(
                              initialValue: _frequency,
                              items: _frequencyOptions
                                  .map((f) => DropdownMenuItem<String>(value: f, child: Text(f)))
                                  .toList(growable: false),
                              onChanged: (v) => setState(() => _frequency = v ?? _frequency),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    _CardSection(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Scheduled Times',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const Spacer(),
                              IconButton.filledTonal(
                                onPressed: _addTime,
                                tooltip: 'Add time',
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(_times.length, (index) {
                            final time = _times[index];
                            final timeText = time.format(context);

                            final delete = _times.length > 1
                                ? IconButton.filledTonal(
                              onPressed: () => _removeTime(index),
                              tooltip: 'Remove time',
                              icon: const Icon(Icons.delete_outline),
                              style: IconButton.styleFrom(
                                foregroundColor: colorScheme.error,
                              ),
                            )
                                : const SizedBox.shrink();

                            final timeField = InkWell(
                              onTap: () => _pickTime(index),
                              borderRadius: BorderRadius.circular(12),
                              child: InputDecorator(
                                decoration: const InputDecoration(),
                                child: Text(timeText),
                              ),
                            );

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Expanded(child: timeField),
                                  const SizedBox(width: 12),
                                  delete,
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    _CardSection(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LabeledField(
                            label: 'Refills Remaining',
                            child: TextFormField(
                              controller: _refillsController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(),
                              validator: (v) {
                                final n = int.tryParse((v ?? '').trim());
                                if (n == null) return 'Enter a number';
                                if (n < 0) return 'Must be 0 or more';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          _LabeledField(
                            label: 'Pharmacy',
                            child: TextFormField(
                              controller: _pharmacyController,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                hintText: 'Pharmacy name and location',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Bottom (sticky) submit area
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    top: false,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLowest,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: leftHandMode ? Alignment.centerLeft : Alignment.centerRight,
                        child: SizedBox(
                          height: 56,
                          child: FilledButton(
                            onPressed: _canSubmit ? _submit : null,
                            child: const Text('Add Medication'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardSection extends StatelessWidget {
  const _CardSection({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: style),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}