import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../config/theme.dart';

class MedicationDetailScreen extends StatelessWidget {
  final String medicationId;

  const MedicationDetailScreen({
    super.key,
    required this.medicationId,
  });

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final medication = appProvider.getMedicationById(medicationId);

    if (medication == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/medications'),
          ),
        ),
        body: const Center(
          child: Text('Medication not found'),
        ),
      );
    }

    final needsRefill = medication.refillsRemaining <= 1;

    return Scaffold(
      backgroundColor: AppTheme.grayBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/medications'),
        ),
        title: const Text('Medication Details'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(isLandscape ? 12 : 16),
          children: [
            // Medication Info Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(isLandscape ? 16 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: isLandscape ? 48 : 56,
                          height: isLandscape ? 48 : 56,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                          ),
                          child: Icon(
                            Icons.medication,
                            color: AppTheme.primaryColor,
                            size: isLandscape ? 28 : 32,
                          ),
                        ),
                        SizedBox(width: isLandscape ? 12 : 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medication.name,
                                style: TextStyle(
                                  fontSize: isLandscape ? 18 : 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                medication.dose,
                                style: TextStyle(
                                  fontSize: isLandscape ? 14 : 16,
                                  color: AppTheme.grayMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isLandscape ? 16 : 20),
                    
                    _InfoRow(
                      label: 'Frequency',
                      value: medication.frequency,
                      isLandscape: isLandscape,
                    ),
                    _InfoRow(
                      label: 'Times',
                      value: medication.times.join(', '),
                      isLandscape: isLandscape,
                    ),
                    _InfoRow(
                      label: 'Pharmacy',
                      value: medication.pharmacy,
                      isLandscape: isLandscape,
                    ),
                    _InfoRow(
                      label: 'Refills',
                      value: '${medication.refillsRemaining} remaining',
                      isLandscape: isLandscape,
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: isLandscape ? 12 : 16),
            
            // Actions
            if (needsRefill)
              Card(
                color: const Color(0xFFFEF3C7),
                child: Padding(
                  padding: EdgeInsets.all(isLandscape ? 12 : 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: AppTheme.warningColor,
                        size: isLandscape ? 20 : 24,
                      ),
                      SizedBox(width: isLandscape ? 8 : 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Refill Needed',
                              style: TextStyle(
                                fontSize: isLandscape ? 14 : 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.warningColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Only ${medication.refillsRemaining} refill${medication.refillsRemaining == 1 ? '' : 's'} remaining',
                              style: TextStyle(
                                fontSize: isLandscape ? 12 : 14,
                                color: AppTheme.warningColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/medications/$medicationId/refill'),
                        child: const Text('Request'),
                      ),
                    ],
                  ),
                ),
              ),
            
            if (needsRefill) SizedBox(height: isLandscape ? 12 : 16),
            
            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      appProvider.takeMedication(medicationId, 'User');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Medication marked as taken'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Mark Taken'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        double.infinity,
                        isLandscape 
                            ? AppTheme.minTouchTargetLandscape 
                            : AppTheme.minTouchTarget,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isLandscape ? 8 : 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      appProvider.skipMedication(medicationId, 'User');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Medication skipped'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('Skip'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(
                        double.infinity,
                        isLandscape 
                            ? AppTheme.minTouchTargetLandscape 
                            : AppTheme.minTouchTarget,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: isLandscape ? 16 : 24),
            
            // History
            const Text(
              'History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isLandscape ? 8 : 12),
            
            if (medication.history.isEmpty)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(isLandscape ? 16 : 20),
                  child: const Center(
                    child: Text(
                      'No history yet',
                      style: TextStyle(color: AppTheme.grayMedium),
                    ),
                  ),
                ),
              )
            else
              ...medication.history.reversed.take(10).map((action) {
                return Card(
                  margin: EdgeInsets.only(bottom: isLandscape ? 6 : 8),
                  child: Padding(
                    padding: EdgeInsets.all(isLandscape ? 10 : 12),
                    child: Row(
                      children: [
                        Icon(
                          action.action == 'taken' ? Icons.check_circle : Icons.cancel,
                          color: action.action == 'taken' 
                              ? AppTheme.successColor 
                              : AppTheme.grayMedium,
                          size: isLandscape ? 18 : 20,
                        ),
                        SizedBox(width: isLandscape ? 8 : 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                action.action == 'taken' ? 'Taken' : 'Skipped',
                                style: TextStyle(
                                  fontSize: isLandscape ? 13 : 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                DateFormat('MMM d, y h:mm a').format(action.timestamp),
                                style: TextStyle(
                                  fontSize: isLandscape ? 11 : 12,
                                  color: AppTheme.grayMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLandscape;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLandscape ? 10 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isLandscape ? 13 : 14,
                color: AppTheme.grayMedium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isLandscape ? 13 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
