import 'package:care_connect/models/appointment.dart';
import 'package:care_connect/providers/app_provider.dart';
import 'package:care_connect/screens/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

void main() {
  group('CalendarScreen Tests', () {
    late SharedPreferences prefs;
    late AppProvider appProvider;

    Widget buildTestableWidget() {
      return ChangeNotifierProvider.value(
        value: appProvider,
        child: const MaterialApp(
          home: CalendarScreen(),
        ),
      );
    }

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      appProvider = AppProvider(prefs);
    });

    testWidgets('Initial state shows current month and appointments', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final currentMonthText = DateFormat('MMMM yyyy').format(DateTime.now());
      expect(find.text(currentMonthText), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
    });

    testWidgets('Month navigation works', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final initialMonth = DateTime.now();
      final nextMonth = DateTime(initialMonth.year, initialMonth.month + 1);
      final prevMonth = DateTime(initialMonth.year, initialMonth.month - 1);

      // Navigate forward
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
      expect(find.text(DateFormat('MMMM yyyy').format(nextMonth)), findsOneWidget);

      // Navigate back twice (to previous month from initial)
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      expect(find.text(DateFormat('MMMM yyyy').format(prevMonth)), findsOneWidget);
    });

    testWidgets('Selecting a date updates the view', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Find a day in the current month grid. 
      // Day '15' is usually safe and visible in most month views.
      final day15 = find.text('15').first; 
      await tester.tap(day15);
      await tester.pumpAndSettle();

      final selectedDate = DateTime(DateTime.now().year, DateTime.now().month, 15);
      final expectedDateText = DateFormat('EEEE, MMMM d').format(selectedDate);
      
      expect(find.text(expectedDateText), findsOneWidget);
    });

    testWidgets('Shows appointments for today', (tester) async {
      // Add a mock appointment for today
      final today = DateTime.now();
      appProvider.addAppointment(
        Appointment(
          id: 'test-apt',
          title: 'Test Doctor Visit',
          date: today,
          time: '2:00 PM',
          location: 'Medical Center',
          provider: 'Dr. Tester',
        ),
      );

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Test Doctor Visit'), findsOneWidget);
      expect(find.text('Dr. Tester'), findsOneWidget);
    });
  });
}
