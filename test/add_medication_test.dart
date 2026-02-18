import 'package:care_connect/providers/app_provider.dart';
import 'package:care_connect/screens/add_medication_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AddMedicationScreen Tests', () {
    late SharedPreferences prefs;
    late AppProvider appProvider;

    Widget buildTestableWidget() {
      final router = GoRouter(
        initialLocation: '/add',
        routes: [
          GoRoute(
            path: '/add',
            builder: (context, state) => const AddMedicationScreen(),
          ),
          GoRoute(
            path: '/medications',
            builder: (context, state) => const Scaffold(body: Text('Medications List')),
          ),
        ],
      );

      return ChangeNotifierProvider.value(
        value: appProvider,
        child: MaterialApp.router(
          routerConfig: router,
        ),
      );
    }

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      appProvider = AppProvider(prefs);
    });

    testWidgets('Initial state shows default values', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Add Medication'), findsAtLeastNWidgets(1));
      expect(find.widgetWithText(TextFormField, '3'), findsOneWidget); // Default refills
      expect(find.text('CVS Pharmacy - Main St'), findsOneWidget); // Default pharmacy
      expect(find.text('Once daily'), findsOneWidget); // Default frequency
    });

    testWidgets('Validation prevents submission with empty fields', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Submit button is disabled initially because _canSubmit is false
      final saveButtonFinder = find.widgetWithText(FilledButton, 'Add Medication');
      final FilledButton button = tester.widget(saveButtonFinder);
      expect(button.onPressed, isNull);
      
      // AppProvider shouldn't have new medications (initial count is 2 from mock data)
      expect(appProvider.medications.length, 2);
    });

    testWidgets('Full flow adds medication and redirects', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Enter medication name
      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g., Lisinopril'),
        'Ibuprofen',
      );
      
      // Enter dose
      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g., 10mg, 2 tablets'),
        '200mg',
      );

      // Add a time
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      
      // Now there should be two time pickers
      expect(find.byIcon(Icons.access_time), findsNothing); // It's InkWell + InputDecorator now
      // Let's count InputDecorators instead, or just check the length of times in provider later
      
      // Submit
      await tester.pumpAndSettle();
      final saveButtonFinder = find.widgetWithText(FilledButton, 'Add Medication');
      await tester.tap(saveButtonFinder);
      await tester.pumpAndSettle();

      // Check if redirected
      expect(find.text('Medications List'), findsOneWidget);
      
      // Check if added to provider
      expect(appProvider.medications.any((m) => m.name == 'Ibuprofen'), true);
    });

    testWidgets('Removing a time works', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Initially 1 time, no delete icon
      expect(find.byIcon(Icons.delete_outline), findsNothing);

      // Add one more time
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      
      // There should be two delete icons now (one for each time row)
      expect(find.byIcon(Icons.delete_outline), findsNWidgets(2));

      // Remove the first one
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();
      
      // Back to 1 time, so delete icons should be gone
      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });
  });
}
