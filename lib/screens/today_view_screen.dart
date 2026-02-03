import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../config/theme.dart';

class TodayViewScreen extends StatelessWidget {
  const TodayViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final today = DateTime.now();
    
    // Get today's medications
    final todayMeds = appProvider.medications.where((med) {
      // For demo, show all medications as "due today"
      return true;
    }).toList();
    
    // Get upcoming appointments
    final upcomingAppointments = appProvider.appointments.where((apt) {
      return apt.date.isAfter(today.subtract(const Duration(days: 1)));
    }).toList();
    
    upcomingAppointments.sort((a, b) => a.date.compareTo(b.date));

    return Scaffold(
      backgroundColor: AppTheme.grayBg,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Today'),
            Text(
              DateFormat('EEEE, MMMM d').format(today),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: AppTheme.grayMedium,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(isLandscape ? 12 : 16),
          children: [
            // Due Medications
            _SectionHeader(
              title: 'Medications Due',
              actionLabel: 'View All',
              onActionTap: () => context.go('/medications'),
            ),
            SizedBox(height: isLandscape ? 8 : 12),
            
            if (todayMeds.isEmpty)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(isLandscape ? 16 : 24),
                  child: const Center(
                    child: Text(
                      'No medications due today',
                      style: TextStyle(color: AppTheme.grayMedium),
                    ),
                  ),
                ),
              )
            else
              ...todayMeds.take(3).map((med) {
                return Padding(
                  padding: EdgeInsets.only(bottom: isLandscape ? 8 : 12),
                  child: Card(
                    child: InkWell(
                      onTap: () => context.go('/medications/${med.id}'),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                      child: Padding(
                        padding: EdgeInsets.all(isLandscape ? 12 : 16),
                        child: Row(
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
                      ),
                    ),
                  ),
                );
              }),
            
            SizedBox(height: isLandscape ? 16 : 24),
            
            // Upcoming Appointments
            _SectionHeader(
              title: 'Upcoming Appointments',
              actionLabel: 'View Calendar',
              onActionTap: () => context.go('/calendar'),
            ),
            SizedBox(height: isLandscape ? 8 : 12),
            
            if (upcomingAppointments.isEmpty)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(isLandscape ? 16 : 24),
                  child: const Center(
                    child: Text(
                      'No upcoming appointments',
                      style: TextStyle(color: AppTheme.grayMedium),
                    ),
                  ),
                ),
              )
            else
              ...upcomingAppointments.take(2).map((apt) {
                return Padding(
                  padding: EdgeInsets.only(bottom: isLandscape ? 8 : 12),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(isLandscape ? 12 : 16),
                      child: Row(
                        children: [
                          Container(
                            width: isLandscape ? 40 : 48,
                            height: isLandscape ? 40 : 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                            ),
                            child: const Icon(
                              Icons.event,
                              color: Color(0xFFEA580C),
                              size: 24,
                            ),
                          ),
                          SizedBox(width: isLandscape ? 12 : 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  apt.title,
                                  style: TextStyle(
                                    fontSize: isLandscape ? 14 : 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${DateFormat('MMM d').format(apt.date)} at ${apt.time}',
                                  style: TextStyle(
                                    fontSize: isLandscape ? 12 : 14,
                                    color: AppTheme.grayMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            
            SizedBox(height: isLandscape ? 16 : 24),
            
            // Quick Actions
            const _SectionHeader(title: 'Quick Actions'),
            SizedBox(height: isLandscape ? 8 : 12),
            
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.add_circle_outline,
                    label: 'Add Medication',
                    onTap: () => context.go('/medications/add'),
                    isLandscape: isLandscape,
                  ),
                ),
                SizedBox(width: isLandscape ? 8 : 12),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.message_outlined,
                    label: 'Message Provider',
                    onTap: () => context.go('/communications'),
                    isLandscape: isLandscape,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.grayDark,
          ),
        ),
        if (actionLabel != null && onActionTap != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLandscape;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        child: Padding(
          padding: EdgeInsets.all(isLandscape ? 16 : 20),
          child: Column(
            children: [
              Icon(
                icon,
                size: isLandscape ? 28 : 32,
                color: AppTheme.primaryColor,
              ),
              SizedBox(height: isLandscape ? 8 : 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isLandscape ? 12 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
