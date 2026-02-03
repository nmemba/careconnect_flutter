import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../config/theme.dart';

class RefillRequestScreen extends StatefulWidget {
  final String medicationId;

  const RefillRequestScreen({
    super.key,
    required this.medicationId,
  });

  @override
  State<RefillRequestScreen> createState() => _RefillRequestScreenState();
}

class _RefillRequestScreenState extends State<RefillRequestScreen> {
  int _currentStep = 0;
  String _pickupMethod = 'pickup';
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    // In a real app, this would submit to a backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refill request submitted successfully'),
        backgroundColor: AppTheme.successColor,
      ),
    );
    context.go('/medications');
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final medication = appProvider.getMedicationById(widget.medicationId);

    if (medication == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/medications'),
          ),
        ),
        body: const Center(child: Text('Medication not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.grayBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/medications/${widget.medicationId}'),
        ),
        title: const Text('Request Refill'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep < 2) {
                    setState(() => _currentStep++);
                  } else {
                    _submitRequest();
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep--);
                  }
                },
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: EdgeInsets.only(top: isLandscape ? 12 : 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: details.onStepContinue,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                double.infinity,
                                isLandscape 
                                    ? AppTheme.minTouchTargetLandscape 
                                    : AppTheme.minTouchTarget,
                              ),
                            ),
                            child: Text(_currentStep == 2 ? 'Submit' : 'Continue'),
                          ),
                        ),
                        if (_currentStep > 0) ...[
                          SizedBox(width: isLandscape ? 8 : 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: details.onStepCancel,
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(
                                  double.infinity,
                                  isLandscape 
                                      ? AppTheme.minTouchTargetLandscape 
                                      : AppTheme.minTouchTarget,
                                ),
                              ),
                              child: const Text('Back'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
                steps: [
                  // Step 1: Confirm Medication
                  Step(
                    title: const Text('Confirm Medication'),
                    content: Card(
                      child: Padding(
                        padding: EdgeInsets.all(isLandscape ? 12 : 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medication.name,
                              style: TextStyle(
                                fontSize: isLandscape ? 16 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: isLandscape ? 6 : 8),
                            Text(
                              '${medication.dose} - ${medication.frequency}',
                              style: TextStyle(
                                fontSize: isLandscape ? 13 : 14,
                                color: AppTheme.grayMedium,
                              ),
                            ),
                            SizedBox(height: isLandscape ? 6 : 8),
                            Text(
                              medication.pharmacy,
                              style: TextStyle(
                                fontSize: isLandscape ? 13 : 14,
                                color: AppTheme.grayMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                  ),
                  
                  // Step 2: Pickup Method
                  Step(
                    title: const Text('Pickup Method'),
                    content: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Pick up at pharmacy'),
                          subtitle: const Text('I\'ll pick up the medication'),
                          value: 'pickup',
                          groupValue: _pickupMethod,
                          onChanged: (value) {
                            setState(() => _pickupMethod = value!);
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Delivery'),
                          subtitle: const Text('Have it delivered to my address'),
                          value: 'delivery',
                          groupValue: _pickupMethod,
                          onChanged: (value) {
                            setState(() => _pickupMethod = value!);
                          },
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 1,
                    state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                  ),
                  
                  // Step 3: Review & Submit
                  Step(
                    title: const Text('Review & Submit'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(isLandscape ? 12 : 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Summary',
                                  style: TextStyle(
                                    fontSize: isLandscape ? 14 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: isLandscape ? 10 : 12),
                                _SummaryRow(
                                  label: 'Medication',
                                  value: medication.name,
                                  isLandscape: isLandscape,
                                ),
                                _SummaryRow(
                                  label: 'Dose',
                                  value: medication.dose,
                                  isLandscape: isLandscape,
                                ),
                                _SummaryRow(
                                  label: 'Pharmacy',
                                  value: medication.pharmacy,
                                  isLandscape: isLandscape,
                                ),
                                _SummaryRow(
                                  label: 'Method',
                                  value: _pickupMethod == 'pickup' 
                                      ? 'Pick up at pharmacy' 
                                      : 'Delivery',
                                  isLandscape: isLandscape,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: isLandscape ? 12 : 16),
                        
                        Text(
                          'Additional Notes (Optional)',
                          style: TextStyle(
                            fontSize: isLandscape ? 13 : 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: isLandscape ? 6 : 8),
                        TextField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Add any special instructions...',
                            constraints: BoxConstraints(
                              minHeight: isLandscape ? 80 : 100,
                            ),
                          ),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 2,
                    state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLandscape;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLandscape ? 6 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isLandscape ? 12 : 13,
                color: AppTheme.grayMedium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isLandscape ? 12 : 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
