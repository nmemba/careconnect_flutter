import 'dart:ui' as ui;
import 'package:care_connect/providers/app_provider.dart';
import 'package:care_connect/screens/refill_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('RefillRequestScreen Tests', () {
    late SharedPreferences prefs;
    late AppProvider appProvider;

    Widget buildRoutedApp({required String initialLocation}) {
      final router = GoRouter(
        initialLocation: initialLocation,
        routes: [
          GoRoute(
            path: '/medications',
            builder: (_, __) =>
            const Scaffold(body: Center(child: Text('Medications'))),
          ),
          GoRoute(
            path: '/medications/:id',
            builder: (_, state) {
              final id = state.pathParameters['id']!;
              return Scaffold(body: Center(child: Text('Medication Details $id')));
            },
          ),
          GoRoute(
            path: '/medications/:id/refill',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ChangeNotifierProvider.value(
                value: appProvider,
                child: RefillRequestScreen(medicationId: id),
              );
            },
          ),
        ],
      );

      return MaterialApp.router(routerConfig: router);
    }

    // Finders scoped to Stepper to avoid duplicates across offstage steps
    // Utility taps to ensure we hit the visible controls only.
    Future<void> tapPrimary(WidgetTester tester) async {
      final primary = find.byKey(const Key('refill_stepper_button'));
      await tester.ensureVisible(primary);
      await tester.pump();
      if (!tester.any(primary)) return; // safety
      try {
        await tester.tap(primary);
      } catch (_) {
        final scrollable = find.byType(Scrollable).first;
        await tester.scrollUntilVisible(primary, 100.0, scrollable: scrollable);
        await tester.pumpAndSettle();
        await tester.tap(primary);
      }
    }

    Future<void> tapBack(WidgetTester tester) async {
      final back = find.widgetWithText(OutlinedButton, 'Back');
      await tester.ensureVisible(back);
      await tester.pump();
      await tester.tap(back);
    }

    setUp(() async {
      // Increase the test surface to avoid controls being off-screen
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.platformDispatcher.views.first.physicalSize = const ui.Size(1200, 2000);
      binding.platformDispatcher.views.first.devicePixelRatio = 1.0;

      SharedPreferences.setMockInitialValues({
        'onboardingComplete': true,
        'leftHandMode': false,
      });
      prefs = await SharedPreferences.getInstance();
      appProvider = AppProvider(prefs);
      await appProvider.login();

      addTearDown(() {
        // Restore to a sane default
        binding.platformDispatcher.views.first.physicalSize = const ui.Size(800, 600);
        binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
      });
    });

    testWidgets('Not found state shows message', (tester) async {
      await tester.pumpWidget(
        buildRoutedApp(initialLocation: '/medications/does-not-exist/refill'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Medication not found'), findsOneWidget);
    });

    testWidgets('Stepper flow: Continue -> Continue -> Submit returns to /medications', (tester) async {
      await tester.pumpWidget(
        buildRoutedApp(initialLocation: '/medications/2/refill'),
      );
      await tester.pumpAndSettle();

      // Step 0: Confirm Medication
      expect(find.text('Confirm Medication'), findsAtLeastNWidgets(1));
      await tapPrimary(tester);
      await tester.pumpAndSettle();

      // Step 1: Pickup Method
      expect(find.text('Pickup Method'), findsAtLeastNWidgets(1));
      await tapPrimary(tester);
      await tester.pumpAndSettle();

      // Step 2: Review & Submit
      expect(find.text('Review & Submit'), findsAtLeastNWidgets(1));
      // In RefillRequestScreen, the button text changes to 'Submit' at Step 2
      // but still uses the same key 'refill_stepper_button'
      await tapPrimary(tester);
      await tester.pumpAndSettle();

      expect(find.text('Medications'), findsOneWidget);
    });

    testWidgets('Back button moves from step 1 to step 0', (tester) async {
      await tester.pumpWidget(
        buildRoutedApp(initialLocation: '/medications/2/refill'),
      );
      await tester.pumpAndSettle();

      await tapPrimary(tester); // to step 1
      await tester.pumpAndSettle();

      expect(find.text('Pickup Method'), findsAtLeastNWidgets(1));
      expect(find.widgetWithText(OutlinedButton, 'Back'), findsOneWidget);

      await tapBack(tester);
      await tester.pumpAndSettle();

      expect(find.text('Confirm Medication'), findsAtLeastNWidgets(1));
    });

    testWidgets('Pickup method radio selection works', (tester) async {
      await tester.pumpWidget(
        buildRoutedApp(initialLocation: '/medications/2/refill'),
      );
      await tester.pumpAndSettle();

      await tapPrimary(tester); // Step 1
      await tester.pumpAndSettle();

      final deliveryTile = find.widgetWithText(RadioListTile<String>, 'Delivery');
      expect(deliveryTile, findsOneWidget);

      await tester.tap(deliveryTile);
      await tester.pumpAndSettle();

      await tapPrimary(tester); // Step 2
      await tester.pumpAndSettle();

      expect(find.text('Summary'), findsOneWidget);
      expect(find.text('Delivery'), findsAtLeastNWidgets(1));
    });

    testWidgets('Notes field is editable', (tester) async {
      await tester.pumpWidget(
        buildRoutedApp(initialLocation: '/medications/2/refill'),
      );
      await tester.pumpAndSettle();

      await tapPrimary(tester); // Step 1
      await tester.pumpAndSettle();
      await tapPrimary(tester); // Step 2
      await tester.pumpAndSettle();

      final notesField = find.byType(TextField);
      expect(notesField, findsOneWidget);

      await tester.enterText(notesField, 'Please expedite');
      await tester.pumpAndSettle();

      expect(find.text('Please expedite'), findsOneWidget);
    });

    testWidgets('App bar back arrow returns to medication details', (tester) async {
      await tester.pumpWidget(
        buildRoutedApp(initialLocation: '/medications/2/refill'),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Medication Details 2'), findsOneWidget);
    });
  });
}
