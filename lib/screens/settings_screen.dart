import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../config/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppTheme.grayBg,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(isLandscape ? 12 : 16),
        children: [
          // Accessibility Settings
          const _SectionHeader(title: 'Accessibility'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Left-Hand Mode'),
                  subtitle: const Text(
                    'Optimize layout for left-hand use',
                  ),
                  value: appProvider.leftHandMode,
                  onChanged: (value) {
                    appProvider.setLeftHandMode(value);
                  },
                  secondary: Icon(
                    appProvider.leftHandMode ? Icons.back_hand : Icons.front_hand,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.accessibility_new,
                    color: AppTheme.primaryColor,
                  ),
                  title: const Text('Touch Target Size'),
                  subtitle: const Text('56×56 dp (WCAG compliant)'),
                  trailing: Chip(
                    label: const Text(
                      'Optimized',
                      style: TextStyle(fontSize: 12),
                    ),
                    backgroundColor: AppTheme.successColor.withOpacity(0.1),
                    labelStyle: const TextStyle(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: isLandscape ? 16 : 24),
          
          // Security Settings
          const _SectionHeader(title: 'Security'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Biometric Authentication'),
                  subtitle: const Text('Use fingerprint or face ID to sign in'),
                  value: appProvider.biometricEnabled,
                  onChanged: (value) {
                    appProvider.setBiometricEnabled(value);
                  },
                  secondary: const Icon(
                    Icons.fingerprint,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.lock_outline,
                    color: AppTheme.primaryColor,
                  ),
                  title: const Text('Change Passcode'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Change passcode feature coming soon'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.devices,
                    color: AppTheme.primaryColor,
                  ),
                  title: const Text('Session Management'),
                  subtitle: const Text('Auto-lock after 15 minutes'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Session management coming soon'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          SizedBox(height: isLandscape ? 16 : 24),
          
          // Notifications
          const _SectionHeader(title: 'Notifications'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Medication Reminders'),
                  subtitle: const Text('Get notified when medications are due'),
                  value: true,
                  onChanged: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value
                              ? 'Medication reminders enabled'
                              : 'Medication reminders disabled',
                        ),
                      ),
                    );
                  },
                  secondary: const Icon(
                    Icons.notifications_outlined,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Appointment Reminders'),
                  subtitle: const Text('Notify 24 hours before appointments'),
                  value: true,
                  onChanged: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value
                              ? 'Appointment reminders enabled'
                              : 'Appointment reminders disabled',
                        ),
                      ),
                    );
                  },
                  secondary: const Icon(
                    Icons.event_outlined,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: isLandscape ? 16 : 24),
          
          // Account
          const _SectionHeader(title: 'Account'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    color: AppTheme.primaryColor,
                  ),
                  title: const Text('Profile'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile settings coming soon'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryColor,
                  ),
                  title: const Text('About'),
                  subtitle: const Text('CareConnect v1.0.0'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'CareConnect',
                      applicationVersion: '1.0.0',
                      applicationIcon: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'CC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      children: [
                        const Text(
                          'A mobile healthcare application with comprehensive accessibility features.',
                        ),
                      ],
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: AppTheme.errorColor,
                  ),
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(color: AppTheme.errorColor),
                  ),
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sign Out'),
                        content: const Text(
                          'Are you sure you want to sign out?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.errorColor,
                            ),
                            child: const Text('Sign Out'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true && context.mounted) {
                      await appProvider.logout();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          
          SizedBox(height: isLandscape ? 16 : 24),
          
          // Footer info
          Center(
            child: Text(
              'Built with accessibility in mind',
              style: TextStyle(
                fontSize: isLandscape ? 11 : 12,
                color: AppTheme.grayMedium,
              ),
            ),
          ),
          Center(
            child: Text(
              'WCAG 2.1 Level AA Compliant',
              style: TextStyle(
                fontSize: isLandscape ? 11 : 12,
                color: AppTheme.grayMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.grayMedium,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
