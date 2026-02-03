import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../config/theme.dart';

class MedicationsScreen extends StatelessWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final medications = appProvider.medications;

    return Scaffold(
      backgroundColor: AppTheme.grayBg,
      appBar: AppBar(
        title: const Text('Medications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/medications/add'),
            tooltip: 'Add Medication',
          ),
        ],
      ),
      body: medications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medication_outlined,
                    size: isLandscape ? 48 : 64,
                    color: AppTheme.grayLight,
                  ),
                  SizedBox(height: isLandscape ? 12 : 16),
                  Text(
                    'No medications added',
                    style: TextStyle(
                      fontSize: isLandscape ? 14 : 16,
                      color: AppTheme.grayMedium,
                    ),
                  ),
                  SizedBox(height: isLandscape ? 16 : 24),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/medications/add'),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Medication'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(isLandscape ? 12 : 16),
              itemCount: medications.length,
              itemBuilder: (context, index) {
                final med = medications[index];
                final needsRefill = med.refillsRemaining <= 1;

                return Padding(
                  padding: EdgeInsets.only(bottom: isLandscape ? 8 : 12),
                  child: Card(
                    child: InkWell(
                      onTap: () => context.go('/medications/${med.id}'),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                      child: Padding(
                        padding: EdgeInsets.all(isLandscape ? 12 : 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: isLandscape ? 40 : 48,
                                  height: isLandscape ? 40 : 48,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryLight,
                                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                                  ),
                                  child: const Icon(
                                    Icons.medication,
                                    color: AppTheme.primaryColor,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: isLandscape ? 12 : 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        med.name,
                                        style: TextStyle(
                                          fontSize: isLandscape ? 14 : 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${med.dose} - ${med.frequency}',
                                        style: TextStyle(
                                          fontSize: isLandscape ? 12 : 14,
                                          color: AppTheme.grayMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: AppTheme.grayLight,
                                  size: isLandscape ? 20 : 24,
                                ),
                              ],
                            ),
                            
                            if (needsRefill) ...[
                              SizedBox(height: isLandscape ? 8 : 12),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isLandscape ? 8 : 12,
                                  vertical: isLandscape ? 4 : 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.warning_amber,
                                      size: isLandscape ? 14 : 16,
                                      color: AppTheme.warningColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${med.refillsRemaining} refill${med.refillsRemaining == 1 ? '' : 's'} remaining',
                                      style: TextStyle(
                                        fontSize: isLandscape ? 11 : 12,
                                        color: AppTheme.warningColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            
                            if (med.lastTaken != null) ...[
                              SizedBox(height: isLandscape ? 8 : 12),
                              Text(
                                'Last taken: ${_formatLastTaken(med.lastTaken!.timestamp)}',
                                style: TextStyle(
                                  fontSize: isLandscape ? 11 : 12,
                                  color: AppTheme.grayMedium,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: medications.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => context.go('/medications/add'),
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  String _formatLastTaken(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
