import 'package:flutter_test/flutter_test.dart';
import 'package:care_connect/models/medication.dart';
import 'package:care_connect/models/appointment.dart';
import 'package:care_connect/models/contact.dart';
import 'package:care_connect/models/message_template.dart';

void main() {
  group('Medication Model Tests', () {
    test('Medication constructor works correctly', () {
      final now = DateTime.now();
      final action = MedicationAction(timestamp: now, user: 'John');
      final medication = Medication(
        id: '1',
        name: 'Aspirin',
        dose: '81mg',
        frequency: 'Daily',
        times: ['08:00'],
        refillsRemaining: 2,
        pharmacy: 'CVS',
        lastTaken: action,
        history: [action],
      );

      expect(medication.id, '1');
      expect(medication.name, 'Aspirin');
      expect(medication.dose, '81mg');
      expect(medication.frequency, 'Daily');
      expect(medication.times, ['08:00']);
      expect(medication.refillsRemaining, 2);
      expect(medication.pharmacy, 'CVS');
      expect(medication.lastTaken, action);
      expect(medication.history, [action]);
    });

    test('Medication copyWith works correctly', () {
      final now = DateTime.now();
      final action = MedicationAction(timestamp: now, user: 'John');
      final medication = Medication(
        id: '1',
        name: 'Aspirin',
        dose: '81mg',
        frequency: 'Daily',
        times: ['08:00'],
        refillsRemaining: 2,
        pharmacy: 'CVS',
        lastTaken: action,
        history: [action],
      );

      final updatedMedication = medication.copyWith(
        name: 'Aspirin Plus',
        refillsRemaining: 1,
      );

      expect(updatedMedication.name, 'Aspirin Plus');
      expect(updatedMedication.refillsRemaining, 1);
      expect(updatedMedication.id, '1');
      expect(updatedMedication.dose, '81mg');
    });

    test('MedicationAction constructor works correctly', () {
      final now = DateTime.now();
      final action = MedicationAction(timestamp: now, user: 'John', action: 'skipped');

      expect(action.timestamp, now);
      expect(action.user, 'John');
      expect(action.action, 'skipped');
    });

    test('MedicationAction default action is taken', () {
      final now = DateTime.now();
      final action = MedicationAction(timestamp: now, user: 'John');

      expect(action.action, 'taken');
    });
  });

  group('Appointment Model Tests', () {
    test('Appointment constructor works correctly', () {
      final now = DateTime.now();
      final appointment = Appointment(
        id: '1',
        title: 'Checkup',
        date: now,
        time: '10:00 AM',
        location: 'Clinic',
        provider: 'Dr. Smith',
      );

      expect(appointment.id, '1');
      expect(appointment.title, 'Checkup');
      expect(appointment.date, now);
      expect(appointment.time, '10:00 AM');
      expect(appointment.location, 'Clinic');
      expect(appointment.provider, 'Dr. Smith');
    });

    test('Appointment copyWith works correctly', () {
      final now = DateTime.now();
      final appointment = Appointment(
        id: '1',
        title: 'Checkup',
        date: now,
        time: '10:00 AM',
        location: 'Clinic',
        provider: 'Dr. Smith',
      );

      final updated = appointment.copyWith(title: 'Follow-up');

      expect(updated.title, 'Follow-up');
      expect(updated.id, '1');
    });
  });

  group('Contact Model Tests', () {
    test('Contact constructor works correctly', () {
      final contact = Contact(
        id: '1',
        name: 'Jane Doe',
        role: 'Nurse',
        phone: '555-0199',
      );

      expect(contact.id, '1');
      expect(contact.name, 'Jane Doe');
      expect(contact.role, 'Nurse');
      expect(contact.phone, '555-0199');
    });
  });

  group('MessageTemplate Model Tests', () {
    test('MessageTemplate constructor works correctly', () {
      final template = MessageTemplate(
        id: '1',
        text: 'Hello',
        category: 'Greeting',
      );

      expect(template.id, '1');
      expect(template.text, 'Hello');
      expect(template.category, 'Greeting');
    });
  });
}
