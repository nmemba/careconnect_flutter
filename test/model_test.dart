import 'package:flutter_test/flutter_test.dart';
import 'package:care_connect/models/medication.dart';
import 'package:care_connect/models/appointment.dart';
import 'package:care_connect/models/contact.dart';
import 'package:care_connect/models/message_template.dart';

void main() {
  group('Medication Model Tests', () {
    test('Medication can be created', () {
      final medication = Medication(
        id: '1',
        name: 'Test Med',
        dose: '10mg',
        frequency: 'Once daily',
        times: ['09:00'],
        refillsRemaining: 3,
        pharmacy: 'Test Pharmacy',
        history: [],
      );

      expect(medication.id, '1');
      expect(medication.name, 'Test Med');
      expect(medication.dose, '10mg');
      expect(medication.frequency, 'Once daily');
      expect(medication.times, ['09:00']);
      expect(medication.refillsRemaining, 3);
      expect(medication.pharmacy, 'Test Pharmacy');
      expect(medication.history, isEmpty);
      expect(medication.lastTaken, isNull);
    });

    test('Medication copyWith creates new instance with updated fields', () {
      final original = Medication(
        id: '1',
        name: 'Original',
        dose: '10mg',
        frequency: 'Once daily',
        times: ['09:00'],
        refillsRemaining: 3,
        pharmacy: 'Pharmacy A',
        history: [],
      );

      final updated = original.copyWith(
        name: 'Updated',
        refillsRemaining: 5,
      );

      expect(updated.id, original.id);
      expect(updated.name, 'Updated');
      expect(updated.dose, original.dose);
      expect(updated.refillsRemaining, 5);
    });

    test('Medication copyWith without params returns identical medication', () {
      final original = Medication(
        id: '1',
        name: 'Test',
        dose: '10mg',
        frequency: 'Once daily',
        times: ['09:00'],
        refillsRemaining: 3,
        pharmacy: 'Pharmacy',
        history: [],
      );

      final copy = original.copyWith();

      expect(copy.id, original.id);
      expect(copy.name, original.name);
      expect(copy.dose, original.dose);
    });
  });

  group('MedicationAction Model Tests', () {
    test('MedicationAction can be created with default action', () {
      final now = DateTime.now();
      final action = MedicationAction(
        timestamp: now,
        user: 'Test User',
      );

      expect(action.timestamp, now);
      expect(action.user, 'Test User');
      expect(action.action, 'taken'); // Default value
    });

    test('MedicationAction can be created with custom action', () {
      final now = DateTime.now();
      final action = MedicationAction(
        timestamp: now,
        user: 'Test User',
        action: 'skipped',
      );

      expect(action.action, 'skipped');
    });
  });

  group('Appointment Model Tests', () {
    test('Appointment can be created', () {
      final date = DateTime(2026, 3, 15);
      final appointment = Appointment(
        id: '1',
        title: 'Doctor Visit',
        date: date,
        time: '14:00',
        location: 'Medical Center',
        provider: 'Dr. Smith',
      );

      expect(appointment.id, '1');
      expect(appointment.title, 'Doctor Visit');
      expect(appointment.date, date);
      expect(appointment.time, '14:00');
      expect(appointment.location, 'Medical Center');
      expect(appointment.provider, 'Dr. Smith');
    });

    test('Appointment copyWith creates new instance with updated fields', () {
      final originalDate = DateTime(2026, 3, 15);
      final newDate = DateTime(2026, 3, 20);
      
      final original = Appointment(
        id: '1',
        title: 'Original Title',
        date: originalDate,
        time: '14:00',
        location: 'Location A',
        provider: 'Dr. A',
      );

      final updated = original.copyWith(
        title: 'Updated Title',
        date: newDate,
      );

      expect(updated.id, original.id);
      expect(updated.title, 'Updated Title');
      expect(updated.date, newDate);
      expect(updated.time, original.time);
      expect(updated.location, original.location);
    });
  });

  group('Contact Model Tests', () {
    test('Contact can be created with phone', () {
      final contact = Contact(
        id: '1',
        name: 'Dr. Smith',
        role: 'Primary Care',
        phone: '555-1234',
      );

      expect(contact.id, '1');
      expect(contact.name, 'Dr. Smith');
      expect(contact.role, 'Primary Care');
      expect(contact.phone, '555-1234');
    });

    test('Contact can be created without phone', () {
      final contact = Contact(
        id: '1',
        name: 'Dr. Smith',
        role: 'Primary Care',
      );

      expect(contact.id, '1');
      expect(contact.name, 'Dr. Smith');
      expect(contact.role, 'Primary Care');
      expect(contact.phone, isNull);
    });
  });

  group('MessageTemplate Model Tests', () {
    test('MessageTemplate can be created', () {
      final template = MessageTemplate(
        id: '1',
        text: 'Running late',
        category: 'appointment',
      );

      expect(template.id, '1');
      expect(template.text, 'Running late');
      expect(template.category, 'appointment');
    });

    test('MessageTemplate supports different categories', () {
      final categories = ['appointment', 'update', 'wellness', 'emergency'];
      
      for (final category in categories) {
        final template = MessageTemplate(
          id: '1',
          text: 'Test',
          category: category,
        );
        
        expect(template.category, category);
      }
    });
  });

  group('Data Validation Tests', () {
    test('Medication times list is mutable', () {
      final medication = Medication(
        id: '1',
        name: 'Test',
        dose: '10mg',
        frequency: 'Twice daily',
        times: ['09:00'],
        refillsRemaining: 3,
        pharmacy: 'Pharmacy',
        history: [],
      );

      final newTimes = [...medication.times, '21:00'];
      final updated = medication.copyWith(times: newTimes);

      expect(updated.times.length, 2);
      expect(updated.times, ['09:00', '21:00']);
    });

    test('Medication history is mutable', () {
      final medication = Medication(
        id: '1',
        name: 'Test',
        dose: '10mg',
        frequency: 'Once daily',
        times: ['09:00'],
        refillsRemaining: 3,
        pharmacy: 'Pharmacy',
        history: [],
      );

      final action = MedicationAction(
        timestamp: DateTime.now(),
        user: 'Test User',
      );

      final newHistory = [...medication.history, action];
      final updated = medication.copyWith(history: newHistory);

      expect(updated.history.length, 1);
      expect(updated.history.first.user, 'Test User');
    });

    test('Medication refills can be zero', () {
      final medication = Medication(
        id: '1',
        name: 'Test',
        dose: '10mg',
        frequency: 'Once daily',
        times: ['09:00'],
        refillsRemaining: 0,
        pharmacy: 'Pharmacy',
        history: [],
      );

      expect(medication.refillsRemaining, 0);
    });

    test('Medication can have multiple times', () {
      final medication = Medication(
        id: '1',
        name: 'Test',
        dose: '10mg',
        frequency: 'Four times daily',
        times: ['08:00', '12:00', '16:00', '20:00'],
        refillsRemaining: 3,
        pharmacy: 'Pharmacy',
        history: [],
      );

      expect(medication.times.length, 4);
      expect(medication.times, ['08:00', '12:00', '16:00', '20:00']);
    });
  });
}
