import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:care_connect/main.dart';
import 'package:care_connect/providers/app_provider.dart';

void main() {
  group('CareConnect App Tests', () {
    setUp(() async {
      // Initialize SharedPreferences mock
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('App loads and shows login screen for unauthenticated user',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppProvider(prefs),
          child: const CareConnectApp(),
        ),
      );

      // Wait for the widget tree to settle
      await tester.pumpAndSettle();

      // Should show login screen
      expect(find.text('CareConnect'), findsOneWidget);
      expect(find.text('Sign In'), findsWidgets);
    });

    testWidgets('Onboarding screen shows when no hand preference is set',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppProvider(prefs),
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Should redirect to onboarding
      expect(find.text('Welcome to CareConnect'), findsOneWidget);
      expect(find.text('Hand Preference'), findsOneWidget);
    });

    testWidgets('Login screen has all required elements',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingComplete', true);
      await prefs.setBool('leftHandMode', false);
      
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppProvider(prefs),
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Check for login elements
      expect(find.text('CareConnect'), findsOneWidget);
      expect(find.text('Your health, simplified'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2)); // Username and password
      expect(find.text('Sign In'), findsWidgets);
    });

    testWidgets('Username and password fields are editable',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingComplete', true);
      
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppProvider(prefs),
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Find username field and enter text
      final usernameField = find.byType(TextField).first;
      await tester.enterText(usernameField, 'testuser');
      expect(find.text('testuser'), findsOneWidget);

      // Find password field and enter text
      final passwordField = find.byType(TextField).last;
      await tester.enterText(passwordField, 'password123');
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('Touch targets meet minimum size requirements',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingComplete', true);
      
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppProvider(prefs),
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Find all buttons
      final buttons = find.byType(ElevatedButton);
      
      for (final button in buttons.evaluate()) {
        final renderBox = button.renderObject as RenderBox;
        final size = renderBox.size;
        
        // Minimum touch target should be at least 48x48 (Material Design minimum)
        expect(size.height, greaterThanOrEqualTo(48.0),
            reason: 'Button height should meet minimum touch target');
      }
    });
  });

  group('Onboarding Tests', () {
    testWidgets('Hand preference can be selected',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppProvider(prefs),
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Should show onboarding
      expect(find.text('Right Hand'), findsOneWidget);
      expect(find.text('Left Hand'), findsOneWidget);

      // Tap left hand option
      await tester.tap(find.text('Left Hand'));
      await tester.pump();

      // Continue button should be visible
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('Onboarding saves hand preference',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      final appProvider = AppProvider(prefs);
      
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appProvider,
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Select left hand
      await tester.tap(find.text('Left Hand'));
      await tester.pump();

      // Tap continue
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Verify preference was saved
      expect(prefs.getBool('leftHandMode'), true);
      expect(prefs.getBool('onboardingComplete'), true);
    });
  });

  group('Settings Tests', () {
    testWidgets('Settings screen shows all options',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingComplete', true);
      final appProvider = AppProvider(prefs);
      await appProvider.login();
      
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appProvider,
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to settings (tap last nav item)
      final settingsTab = find.text('Settings');
      await tester.tap(settingsTab);
      await tester.pumpAndSettle();

      // Check for settings sections
      expect(find.text('Accessibility'), findsOneWidget);
      expect(find.text('Security'), findsOneWidget);
      expect(find.text('Left-Hand Mode'), findsOneWidget);
      expect(find.text('Biometric Authentication'), findsOneWidget);
    });

    testWidgets('Left-hand mode toggle works',
        (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingComplete', true);
      await prefs.setBool('leftHandMode', false);
      
      final appProvider = AppProvider(prefs);
      await appProvider.login();
      
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appProvider,
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Initial state should be off
      expect(appProvider.leftHandMode, false);

      // Find and tap the left-hand mode switch
      final switchFinder = find.byWidgetPredicate(
        (widget) =>
            widget is SwitchListTile &&
            widget.title is Text &&
            (widget.title as Text).data == 'Left-Hand Mode',
      );

      await tester.tap(switchFinder);
      await tester.pump();

      // Verify it was toggled
      expect(appProvider.leftHandMode, true);
      expect(prefs.getBool('leftHandMode'), true);
    });
  });
}
