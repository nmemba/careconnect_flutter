import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../config/theme.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: isLandscape ? 24 : 48,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          width: isLandscape ? 56 : 64,
                          height: isLandscape ? 56 : 64,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              'CC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isLandscape ? 20 : 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: isLandscape ? 16 : 24),
                        
                        // Title
                        Text(
                          'Welcome to CareConnect',
                          style: TextStyle(
                            fontSize: isLandscape ? 24 : 30,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.grayDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isLandscape ? 8 : 12),
                        
                        Text(
                          "Let's personalize your experience",
                          style: TextStyle(
                            fontSize: isLandscape ? 14 : 16,
                            color: AppTheme.grayMedium,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isLandscape ? 24 : 32),
                        
                        // Hand Preference Card
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(isLandscape ? 16 : 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hand Preference',
                                  style: TextStyle(
                                    fontSize: isLandscape ? 16 : 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.grayDark,
                                  ),
                                ),
                                SizedBox(height: isLandscape ? 12 : 16),
                                
                                Text(
                                  'Choose your preferred hand for easier one-handed use. This moves buttons and controls to your thumb zone.',
                                  style: TextStyle(
                                    fontSize: isLandscape ? 12 : 14,
                                    color: AppTheme.grayMedium,
                                  ),
                                ),
                                SizedBox(height: isLandscape ? 12 : 16),
                                
                                // Hand selection buttons
                                Row(
                                  children: [
                                    Expanded(
                                      child: _HandOptionButton(
                                        emoji: '🤚',
                                        label: 'Right Hand',
                                        isSelected: !appProvider.leftHandMode,
                                        onTap: () => appProvider.setLeftHandMode(false),
                                        isLandscape: isLandscape,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _HandOptionButton(
                                        emoji: '🖐️',
                                        label: 'Left Hand',
                                        isSelected: appProvider.leftHandMode,
                                        onTap: () => appProvider.setLeftHandMode(true),
                                        isLandscape: isLandscape,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Continue Button
            Container(
              padding: EdgeInsets.all(isLandscape ? 16 : 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppTheme.grayBorder),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Align(
                  alignment: appProvider.leftHandMode 
                      ? Alignment.centerLeft 
                      : Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      await appProvider.completeOnboarding();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        AppTheme.minTouchTarget,
                        isLandscape 
                            ? AppTheme.minTouchTargetLandscape 
                            : AppTheme.minTouchTarget,
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HandOptionButton extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLandscape;

  const _HandOptionButton({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      child: Container(
        constraints: BoxConstraints(
          minHeight: isLandscape 
              ? AppTheme.minTouchTargetLandscape 
              : AppTheme.minTouchTarget,
        ),
        padding: EdgeInsets.all(isLandscape ? 12 : 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryLight : Colors.white,
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.grayBorder,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: isLandscape ? 24 : 32),
            ),
            SizedBox(height: isLandscape ? 4 : 8),
            Text(
              label,
              style: TextStyle(
                fontSize: isLandscape ? 12 : 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.grayDark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
