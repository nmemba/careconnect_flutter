import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:care_connect/main.dart';
import 'package:care_connect/providers/app_provider.dart';

/// Integration tests that simulate real user workflows
void main() {
  /*group('User Flow: First Time User', () {
    testWidgets('Complete onboarding and login flow',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AppProvider(prefs),
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Step 1: Should show onboarding
      expect(find.text('Welcome to CareConnect'), findsOneWidget);

      // Step 2: Select left hand preference
      await tester.tap(find.text('Left Hand'));
      await tester.pump();

      // Step 3: Continue to login
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 4: Should now be on login screen
      expect(find.text('Sign In'), findsWidgets);
      expect(find.text('CareConnect'), findsOneWidget);

      // Verify hand preference was saved
      expect(prefs.getBool('leftHandMode'), true);
      expect(prefs.getBool('onboardingComplete'), true);
    });
  });

  group('User Flow: Returning User', () {
    testWidgets('Skip onboarding and go directly to login',
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

      // Should go directly to login, skipping onboarding
      expect(find.text('Welcome to CareConnect'), findsNothing);
      expect(find.text('Sign In'), findsWidgets);
    });

    testWidgets('Login and access main app', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'leftHandMode': false,
        'onboardingComplete': true,
      });
      final prefs = await SharedPreferences.getInstance();
      final appProvider = AppProvider(prefs);
      
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appProvider,
          child: const CareConnectApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Enter credentials
      final usernameField = find.byType(TextField).first;
      await tester.enterText(usernameField, 'demo');
      
      final passwordField = find.byType(TextField).last;
      await tester.enterText(passwordField, 'demo123');

      // Tap sign in button
      final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      // Should navigate to Today view
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Medications Due'), findsOneWidget);
    });
  });

  group('User Flow: Medication Management', () {
    testWidgets('View and take medication', (WidgetTester tester) async {
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

      // Navigate to medications
      await tester.tap(find.text('Meds'));
      await tester.pumpAndSettle();

      // Should show medication list
      expect(find.text('Medications'), findsOneWidget);
      
      // Tap on first medication
      final firstMed = appProvider.medications.first;
      await tester.tap(find.text(firstMed.name).first);
      await tester.pumpAndSettle();

      // Should show medication details
      expect(find.text('Medication Details'), findsOneWidget);
      expect(find.text(firstMed.name), findsOneWidget);

      // Mark as taken
      await tester.tap(find.text('Mark Taken'));
      await tester.pump();

      // Verify snackbar appears
      expect(find.text('Medication marked as taken'), findsOneWidget);
    });

    testWidgets('Add new medication', (WidgetTester tester) async {
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

      // Navigate to medications
      await tester.tap(find.text('Meds'));
      await tester.pumpAndSettle();

      final initialCount = appProvider.medications.length;

      // Tap add button
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();

      // Should show add medication screen
      expect(find.text('Add Medication'), findsOneWidget);

      // Fill in form
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter medication name'),
        'Aspirin',
      );
      
      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g., 10mg'),
        '81mg',
      );
      
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter pharmacy name'),
        'CVS Pharmacy',
      );

      // Save medication
      await tester.tap(find.text('Save Medication'));
      await tester.pumpAndSettle();

      // Should navigate back and medication should be added
      expect(appProvider.medications.length, initialCount + 1);
      expect(appProvider.medications.last.name, 'Aspirin');
    });
  });

  group('User Flow: Navigation', () {
    testWidgets('Navigate through all main screens',
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

      // Today view
      expect(find.text('Today'), findsOneWidget);

      // Navigate to Medications
      await tester.tap(find.text('Meds'));
      await tester.pumpAndSettle();
      expect(find.text('Medications'), findsOneWidget);

      // Navigate to Calendar
      await tester.tap(find.text('Calendar'));
      await tester.pumpAndSettle();
      expect(find.text('Calendar'), findsAtLeastNWidgets(1));

      // Navigate to Messages
      await tester.tap(find.text('Messages'));
      await tester.pumpAndSettle();
      expect(find.text('Messages'), findsOneWidget);

      // Navigate to Settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsAtLeastNWidgets(1));
      expect(find.text('Accessibility'), findsOneWidget);

      // Navigate back to Today
      await tester.tap(find.text('Today'));
      await tester.pumpAndSettle();
      expect(find.text('Medications Due'), findsOneWidget);
    });
  });

  group('User Flow: Settings Management', () {
    testWidgets('Change settings and verify persistence',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'leftHandMode': false,
        'onboardingComplete': true,
        'biometricEnabled': true,
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

      // Verify initial states
      expect(appProvider.leftHandMode, false);
      expect(appProvider.biometricEnabled, true);

      // Toggle left-hand mode
      final leftHandSwitch = find.byWidgetPredicate(
        (widget) =>
            widget is SwitchListTile &&
            widget.title is Text &&
            (widget.title as Text).data == 'Left-Hand Mode',
      );
      await tester.tap(leftHandSwitch);
      await tester.pump();

      // Verify changes
      expect(appProvider.leftHandMode, true);
      expect(prefs.getBool('leftHandMode'), true);

      // Toggle biometric
      final biometricSwitch = find.byWidgetPredicate(
        (widget) =>
            widget is SwitchListTile &&
            widget.title is Text &&
            (widget.title as Text).data == 'Biometric Authentication',
      );
      await tester.tap(biometricSwitch);
      await tester.pump();

      // Verify changes
      expect(appProvider.biometricEnabled, false);
      expect(prefs.getBool('biometricEnabled'), false);
    });
  });*/

  group('User Flow: Refill Request', () {
    testWidgets('Complete 3-step refill request', (WidgetTester tester) async {
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

      // Navigate to medications
      await tester.tap(find.text('Meds'));
      await tester.pumpAndSettle();

      // Tap on first medication
      final firstMed = appProvider.medications.first;
      await tester.tap(find.text(firstMed.name).first);
      await tester.pumpAndSettle();

      // Check if refill warning is shown (if refills <= 1)
      if (firstMed.refillsRemaining <= 1) {
        // Tap request refill
        await tester.tap(find.text('Request'));
        await tester.pumpAndSettle();

        // Step 1: Confirm medication
        expect(find.text('Request Refill'), findsOneWidget);
        expect(find.text('Confirm Medication'), findsOneWidget);
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        // Step 2: Pickup method
        expect(find.text('Pickup Method'), findsOneWidget);
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        // Step 3: Review and submit
        expect(find.text('Review & Submit'), findsOneWidget);
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();

        // Should show success message
        expect(find.text('Refill request submitted successfully'), findsOneWidget);
      }
    });
  });
}
