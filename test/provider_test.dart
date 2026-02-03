import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:care_connect/providers/app_provider.dart';
import 'package:care_connect/models/medication.dart';
import 'package:care_connect/models/appointment.dart';

void main() {
  group('AppProvider Tests', () {
    late AppProvider appProvider;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      appProvider = AppProvider(prefs);
    });

    test('Initial state is unauthenticated', () {
      expect(appProvider.isAuthenticated, false);
    });

    test('Login changes authentication state', () async {
      expect(appProvider.isAuthenticated, false);
      
      await appProvider.login();
      
      expect(appProvider.isAuthenticated, true);
    });

    test('Logout changes authentication state', () async {
      await appProvider.login();
      expect(appProvider.isAuthenticated, true);
      
      await appProvider.logout();
      
      expect(appProvider.isAuthenticated, false);
    });

    test('Left-hand mode persists to storage', () async {
      expect(appProvider.leftHandMode, false);
      
      await appProvider.setLeftHandMode(true);
      
      expect(appProvider.leftHandMode, true);
      expect(prefs.getBool('leftHandMode'), true);
    });

    test('Biometric setting persists to storage', () async {
      expect(appProvider.biometricEnabled, true); // Default is true
      
      await appProvider.setBiometricEnabled(false);
      
      expect(appProvider.biometricEnabled, false);
      expect(prefs.getBool('biometricEnabled'), false);
    });

    test('Settings are loaded from storage on init', () async {
      await prefs.setBool('leftHandMode', true);
      await prefs.setBool('biometricEnabled', false);
      
      final newProvider = AppProvider(prefs);
      
      expect(newProvider.leftHandMode, true);
      expect(newProvider.biometricEnabled, false);
    });

    test('Onboarding completion is tracked', () async {
      expect(appProvider.needsOnboarding, true);
      
      await appProvider.completeOnboarding();
      
      expect(prefs.getBool('onboardingComplete'), true);
    });

    test('User needs onboarding when no hand preference is set', () async {
      await prefs.clear();
      final newProvider = AppProvider(prefs);
      
      expect(newProvider.needsOnboarding, true);
    });

    test('User does not need onboarding when hand preference is set', () async {
      await prefs.setBool('leftHandMode', false);
      final newProvider = AppProvider(prefs);
      
      expect(newProvider.needsOnboarding, false);
    });
  });

  group('Medication Management Tests', () {
    late AppProvider appProvider;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      appProvider = AppProvider(prefs);
    });

    test('Initial medications are loaded', () {
      expect(appProvider.medications.isNotEmpty, true);
      expect(appProvider.medications.length, 2); // Mock data has 2 medications
    });

    test('Can add new medication', () {
      final initialCount = appProvider.medications.length;
      
      final newMed = Medication(
        id: '',
        name: 'Aspirin',
        dose: '81mg',
        frequency: 'Once daily',
        times: ['08:00'],
        refillsRemaining: 5,
        pharmacy: 'Test Pharmacy',
        history: [],
      );

      appProvider.addMedication(newMed);
      
      expect(appProvider.medications.length, initialCount + 1);
      expect(appProvider.medications.last.name, 'Aspirin');
    });

    test('Can find medication by ID', () {
      final med = appProvider.medications.first;
      final found = appProvider.getMedicationById(med.id);
      
      expect(found, isNotNull);
      expect(found!.id, med.id);
      expect(found.name, med.name);
    });

    test('Returns null for non-existent medication ID', () {
      final found = appProvider.getMedicationById('non-existent-id');
      
      expect(found, isNull);
    });

    test('Can mark medication as taken', () {
      final med = appProvider.medications.first;
      final initialHistoryLength = med.history.length;
      
      appProvider.takeMedication(med.id, 'Test User');
      
      final updated = appProvider.getMedicationById(med.id)!;
      expect(updated.history.length, initialHistoryLength + 1);
      expect(updated.history.last.action, 'taken');
      expect(updated.history.last.user, 'Test User');
      expect(updated.lastTaken, isNotNull);
    });

    test('Can skip medication', () {
      final med = appProvider.medications.first;
      final initialHistoryLength = med.history.length;
      
      appProvider.skipMedication(med.id, 'Test User');
      
      final updated = appProvider.getMedicationById(med.id)!;
      expect(updated.history.length, initialHistoryLength + 1);
      expect(updated.history.last.action, 'skipped');
      expect(updated.history.last.user, 'Test User');
    });

    test('Can undo last action', () {
      final med = appProvider.medications.first;
      final initialHistoryLength = med.history.length;
      
      // Take medication
      appProvider.takeMedication(med.id, 'Test User');
      expect(appProvider.getMedicationById(med.id)!.history.length,
          initialHistoryLength + 1);
      
      // Undo
      appProvider.undoLastAction(med.id);
      
      final updated = appProvider.getMedicationById(med.id)!;
      expect(updated.history.length, initialHistoryLength);
    });

    test('Medication history maintains correct order', () {
      final med = appProvider.medications.first;
      
      appProvider.takeMedication(med.id, 'User 1');
      appProvider.skipMedication(med.id, 'User 2');
      appProvider.takeMedication(med.id, 'User 3');
      
      final updated = appProvider.getMedicationById(med.id)!;
      final history = updated.history;
      
      // Should be in chronological order
      expect(history[history.length - 3].user, 'User 1');
      expect(history[history.length - 2].user, 'User 2');
      expect(history[history.length - 1].user, 'User 3');
    });
  });

  group('Appointment Management Tests', () {
    late AppProvider appProvider;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      appProvider = AppProvider(prefs);
    });

    test('Initial appointments are loaded', () {
      expect(appProvider.appointments.isNotEmpty, true);
      expect(appProvider.appointments.length, 2); // Mock data has 2 appointments
    });

    test('Can add new appointment', () {
      final initialCount = appProvider.appointments.length;
      
      final newApt = Appointment(
        id: '',
        title: 'Annual Checkup',
        date: DateTime(2026, 3, 15),
        time: '10:00',
        location: 'Medical Center',
        provider: 'Dr. Johnson',
      );

      appProvider.addAppointment(newApt);
      
      expect(appProvider.appointments.length, initialCount + 1);
      expect(appProvider.appointments.last.title, 'Annual Checkup');
    });
  });

  group('Favorites Management Tests', () {
    late AppProvider appProvider;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      appProvider = AppProvider(prefs);
    });

    test('Default favorites are set', () {
      expect(appProvider.favorites.contains('/medications'), true);
      expect(appProvider.favorites.contains('/calendar'), true);
    });

    test('Can toggle favorite on', () async {
      expect(appProvider.favorites.contains('/communications'), false);
      
      await appProvider.toggleFavorite('/communications');
      
      expect(appProvider.favorites.contains('/communications'), true);
      expect(prefs.getStringList('favorites')!.contains('/communications'), true);
    });

    test('Can toggle favorite off', () async {
      expect(appProvider.favorites.contains('/medications'), true);
      
      await appProvider.toggleFavorite('/medications');
      
      expect(appProvider.favorites.contains('/medications'), false);
    });

    test('Favorites persist to storage', () async {
      await appProvider.toggleFavorite('/settings');
      
      final newProvider = AppProvider(prefs);
      
      expect(newProvider.favorites.contains('/settings'), true);
    });
  });

  group('Communication Tests', () {
    late AppProvider appProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      appProvider = AppProvider(prefs);
    });

    test('Message templates are loaded', () {
      expect(appProvider.messageTemplates.isNotEmpty, true);
      expect(appProvider.messageTemplates.length, greaterThanOrEqualTo(3));
    });

    test('Contacts are loaded', () {
      expect(appProvider.contacts.isNotEmpty, true);
      expect(appProvider.contacts.length, greaterThanOrEqualTo(2));
    });

    test('Message templates have correct structure', () {
      final template = appProvider.messageTemplates.first;
      
      expect(template.id, isNotEmpty);
      expect(template.text, isNotEmpty);
      expect(template.category, isNotEmpty);
    });

    test('Contacts have correct structure', () {
      final contact = appProvider.contacts.first;
      
      expect(contact.id, isNotEmpty);
      expect(contact.name, isNotEmpty);
      expect(contact.role, isNotEmpty);
    });
  });
}
