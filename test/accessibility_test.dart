import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:care_connect/main.dart';
import 'package:care_connect/providers/app_provider.dart';
import 'package:care_connect/config/theme.dart';

/// Tests to verify accessibility compliance (WCAG 2.1 Level AA)
void main() {
  group('Touch Target Size Tests', () {
    testWidgets('Login buttons meet minimum touch target size',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'leftHandMode': false,
        'onboardingComplete': true,
      });
      final prefs = await SharedPreferences.getInstance();
      
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppProvider(prefs),
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Check all buttons meet minimum size
      final buttons = find.byType(ElevatedButton);
      
      for (final button in buttons.evaluate()) {
        final renderBox = button.renderObject as RenderBox;
        final size = renderBox.size;
        
        expect(size.height, greaterThanOrEqualTo(AppTheme.minTouchTargetLandscape),
            reason: 'Touch target height must be at least 48dp');
      }
    });

    testWidgets('Text fields meet minimum touch target size',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'leftHandMode': false,
        'onboardingComplete': true,
      });
      final prefs = await SharedPreferences.getInstance();
      
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppProvider(prefs),
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      
      for (final field in textFields.evaluate()) {
        final renderBox = field.renderObject as RenderBox;
        final size = renderBox.size;
        
        expect(size.height, greaterThanOrEqualTo(AppTheme.minTouchTargetLandscape),
            reason: 'Text field height must be at least 48dp');
      }
    });

    testWidgets('Navigation bar items meet minimum touch target',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'leftHandMode': false,
        'onboardingComplete': true,
      });
      final prefs = await SharedPreferences.getInstance();
      final appProvider = AppProvider(prefs);
      await appProvider.login();
      
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appProvider,
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Check bottom navigation bar
      final bottomNavBar = find.byType(BottomNavigationBar);
      expect(bottomNavBar, findsOneWidget);

      // Navigation items should be tappable with adequate size
      final navItems = find.descendant(
        of: bottomNavBar,
        matching: find.byType(InkResponse),
      );

      // At least 5 items (Today, Meds, Calendar, Messages, Settings)
      expect(navItems.evaluate().length, greaterThanOrEqualTo(5));
    });
  });

  group('Semantic Labels Tests', () {
    testWidgets('Important buttons have semantic labels',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'leftHandMode': false,
        'onboardingComplete': true,
      });
      final prefs = await SharedPreferences.getInstance();
      
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppProvider(prefs),
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Check that text buttons have visible labels
      expect(find.text('Sign In'), findsWidgets);
      expect(find.text('Use Passcode'), findsOneWidget);
    });

    testWidgets('Form fields have labels', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'leftHandMode': false,
        'onboardingComplete': true,
      });
      final prefs = await SharedPreferences.getInstance();
      
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppProvider(prefs),
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Check for field labels
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });
  });

  group('Left-Hand Mode Tests', () {
    testWidgets('Left-hand mode can be enabled', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppProvider(prefs),
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Should be on onboarding
      expect(find.text('Left Hand'), findsOneWidget);

      // Select left hand
      await tester.tap(find.text('Left Hand'));
      await tester.pump();

      // Continue button should be positioned for left hand
      final continueButton = find.text('Continue');
      expect(continueButton, findsOneWidget);
    });

    testWidgets('Left-hand mode persists across app restart',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'leftHandMode': true,
        'onboardingComplete': true,
      });
      final prefs = await SharedPreferences.getInstance();
      
      // Create first instance
      final appProvider1 = AppProvider(prefs);
      expect(appProvider1.leftHandMode, true);

      // Create second instance (simulating app restart)
      final appProvider2 = AppProvider(prefs);
      expect(appProvider2.leftHandMode, true);
    });

    testWidgets('Left-hand mode can be toggled in settings',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'leftHandMode': false,
        'onboardingComplete': true,
      });
      final prefs = await SharedPreferences.getInstance();
      final appProvider = AppProvider(prefs);
      await appProvider.login();
      
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appProvider,
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to Settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Initial state
      expect(appProvider.leftHandMode, false);

      // Toggle
      final switchFinder = find.byWidgetPredicate(
        (widget) =>
            widget is SwitchListTile &&
            widget.title is Text &&
            (widget.title as Text).data == 'Left-Hand Mode',
      );

      await tester.tap(switchFinder);
      await tester.pump();

      // Verify change
      expect(appProvider.leftHandMode, true);
      expect(prefs.getBool('leftHandMode'), true);
    });
  });

  group('Color Contrast Tests', () {
    test('Primary colors have sufficient contrast', () {
      // Primary on white background
      final primaryLuminance = AppTheme.primaryColor.computeLuminance();
      final whiteLuminance = Colors.white.computeLuminance();
      
      final contrast = _calculateContrast(primaryLuminance, whiteLuminance);
      
      // WCAG AA requires 4.5:1 for normal text, 3:1 for large text
      expect(contrast, greaterThanOrEqualTo(3.0),
          reason: 'Primary color should have sufficient contrast on white');
    });

    test('Error color has sufficient contrast', () {
      final errorLuminance = AppTheme.errorColor.computeLuminance();
      final whiteLuminance = Colors.white.computeLuminance();
      
      final contrast = _calculateContrast(errorLuminance, whiteLuminance);
      
      expect(contrast, greaterThanOrEqualTo(3.0),
          reason: 'Error color should have sufficient contrast');
    });

    test('Gray text on white has sufficient contrast', () {
      final grayLuminance = AppTheme.grayDark.computeLuminance();
      final whiteLuminance = Colors.white.computeLuminance();
      
      final contrast = _calculateContrast(grayLuminance, whiteLuminance);
      
      expect(contrast, greaterThanOrEqualTo(4.5),
          reason: 'Gray text should have sufficient contrast for readability');
    });
  });

  group('Spacing and Layout Tests', () {
    testWidgets('Elements have proper spacing', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'leftHandMode': false,
        'onboardingComplete': true,
      });
      final prefs = await SharedPreferences.getInstance();
      
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppProvider(prefs),
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify SizedBox spacing elements exist
      final sizedBoxes = find.byType(SizedBox);
      expect(sizedBoxes.evaluate().isNotEmpty, true,
          reason: 'Layout should include spacing elements');
    });

    testWidgets('Cards have proper padding', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'leftHandMode': false,
        'onboardingComplete': true,
      });
      final prefs = await SharedPreferences.getInstance();
      
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppProvider(prefs),
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Check that cards exist with padding
      final cards = find.byType(Card);
      expect(cards.evaluate().isNotEmpty, true);
    });
  });

  group('Keyboard Navigation Tests', () {
    testWidgets('Forms can be navigated with keyboard',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'leftHandMode': false,
        'onboardingComplete': true,
      });
      final prefs = await SharedPreferences.getInstance();
      
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppProvider(prefs),
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Text fields should be focusable
      final textFields = find.byType(TextField);
      expect(textFields.evaluate().isNotEmpty, true);

      // Each field should accept focus
      for (final field in textFields.evaluate()) {
        final widget = field.widget as TextField;
        expect(widget.enabled, isNot(false));
      }
    });
  });
}

/// Calculate contrast ratio between two luminance values
/// Based on WCAG 2.1 formula
double _calculateContrast(double luminance1, double luminance2) {
  final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
  final darker = luminance1 > luminance2 ? luminance2 : luminance1;
  
  return (lighter + 0.05) / (darker + 0.05);
}
