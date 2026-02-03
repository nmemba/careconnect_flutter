import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medication.dart';
import '../models/appointment.dart';
import '../models/contact.dart';
import '../models/message_template.dart';

/// Main application state provider
/// Manages authentication, settings, medications, appointments, and other app data
class AppProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  
  bool _isAuthenticated = false;
  bool _leftHandMode = false;
  bool _biometricEnabled = true;
  List<Medication> _medications = [];
  List<Appointment> _appointments = [];
  List<MessageTemplate> _messageTemplates = [];
  List<Contact> _contacts = [];
  Set<String> _favorites = {};

  AppProvider(this._prefs) {
    _loadSettings();
    _initializeMockData();
  }

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get leftHandMode => _leftHandMode;
  bool get biometricEnabled => _biometricEnabled;
  List<Medication> get medications => _medications;
  List<Appointment> get appointments => _appointments;
  List<MessageTemplate> get messageTemplates => _messageTemplates;
  List<Contact> get contacts => _contacts;
  Set<String> get favorites => _favorites;
  
  /// Check if user needs to go through onboarding
  bool get needsOnboarding {
    final hasHandPreference = _prefs.containsKey('leftHandMode');
    final onboardingComplete = _prefs.getBool('onboardingComplete') ?? false;
    return !hasHandPreference && !onboardingComplete;
  }

  // Load settings from SharedPreferences
  void _loadSettings() {
    _leftHandMode = _prefs.getBool('leftHandMode') ?? false;
    _biometricEnabled = _prefs.getBool('biometricEnabled') ?? true;
    
    final favoritesJson = _prefs.getStringList('favorites');
    if (favoritesJson != null) {
      _favorites = favoritesJson.toSet();
    } else {
      _favorites = {'/medications', '/calendar'};
    }
  }

  // Initialize mock data
  void _initializeMockData() {
    _medications = [
      Medication(
        id: '1',
        name: 'Lisinopril',
        dose: '10mg',
        frequency: 'Once daily',
        times: ['09:00'],
        refillsRemaining: 2,
        pharmacy: 'CVS Pharmacy - Main St',
        history: [],
      ),
      Medication(
        id: '2',
        name: 'Metformin',
        dose: '500mg',
        frequency: 'Twice daily',
        times: ['08:00', '20:00'],
        refillsRemaining: 1,
        pharmacy: 'CVS Pharmacy - Main St',
        history: [],
      ),
    ];

    _appointments = [
      Appointment(
        id: '1',
        title: 'Dr. Smith - Follow-up',
        date: DateTime(2026, 1, 27),
        time: '14:00',
        location: 'City Medical Center',
        provider: 'Dr. Sarah Smith',
      ),
      Appointment(
        id: '2',
        title: 'Physical Therapy',
        date: DateTime(2026, 1, 28),
        time: '10:30',
        location: 'Rehab Center',
        provider: 'John Davis, PT',
      ),
    ];

    _messageTemplates = [
      MessageTemplate(
        id: '1',
        text: 'Running late, will be there in 15 minutes',
        category: 'appointment',
      ),
      MessageTemplate(
        id: '2',
        text: 'Medication taken as scheduled',
        category: 'update',
      ),
      MessageTemplate(
        id: '3',
        text: 'Need to reschedule appointment',
        category: 'appointment',
      ),
      MessageTemplate(
        id: '4',
        text: 'Feeling better today',
        category: 'wellness',
      ),
    ];

    _contacts = [
      Contact(
        id: '1',
        name: 'Dr. Sarah Smith',
        role: 'Primary Care',
        phone: '555-0100',
      ),
      Contact(
        id: '2',
        name: 'John Davis, PT',
        role: 'Physical Therapist',
        phone: '555-0200',
      ),
      Contact(
        id: '3',
        name: 'Care Coordinator',
        role: 'Support',
        phone: '555-0300',
      ),
    ];
  }

  // Authentication
  Future<void> login() async {
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    notifyListeners();
  }

  // Settings
  Future<void> setLeftHandMode(bool value) async {
    _leftHandMode = value;
    await _prefs.setBool('leftHandMode', value);
    notifyListeners();
  }

  Future<void> setBiometricEnabled(bool value) async {
    _biometricEnabled = value;
    await _prefs.setBool('biometricEnabled', value);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await _prefs.setBool('onboardingComplete', true);
    notifyListeners();
  }

  // Favorites
  Future<void> toggleFavorite(String path) async {
    if (_favorites.contains(path)) {
      _favorites.remove(path);
    } else {
      _favorites.add(path);
    }
    await _prefs.setStringList('favorites', _favorites.toList());
    notifyListeners();
  }

  // Medications
  void addMedication(Medication medication) {
    final newMed = medication.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _medications.add(newMed);
    notifyListeners();
  }

  Medication? getMedicationById(String id) {
    try {
      return _medications.firstWhere((med) => med.id == id);
    } catch (e) {
      return null;
    }
  }

  void takeMedication(String id, String user) {
    final index = _medications.indexWhere((med) => med.id == id);
    if (index != -1) {
      final med = _medications[index];
      final now = DateTime.now();
      
      final updatedMed = med.copyWith(
        lastTaken: MedicationAction(timestamp: now, user: user),
        history: [
          ...med.history,
          MedicationAction(timestamp: now, user: user, action: 'taken'),
        ],
      );
      
      _medications[index] = updatedMed;
      notifyListeners();
    }
  }

  void skipMedication(String id, String user) {
    final index = _medications.indexWhere((med) => med.id == id);
    if (index != -1) {
      final med = _medications[index];
      final now = DateTime.now();
      
      final updatedMed = med.copyWith(
        history: [
          ...med.history,
          MedicationAction(timestamp: now, user: user, action: 'skipped'),
        ],
      );
      
      _medications[index] = updatedMed;
      notifyListeners();
    }
  }

  void undoLastAction(String id) {
    final index = _medications.indexWhere((med) => med.id == id);
    if (index != -1) {
      final med = _medications[index];
      if (med.history.isNotEmpty) {
        final newHistory = List<MedicationAction>.from(med.history);
        newHistory.removeLast();
        
        MedicationAction? newLastTaken;
        if (newHistory.isNotEmpty) {
          final lastTaken = newHistory.reversed.firstWhere(
            (action) => action.action == 'taken',
            orElse: () => MedicationAction(
              timestamp: DateTime.now(),
              user: '',
              action: 'taken',
            ),
          );
          if (lastTaken.user.isNotEmpty) {
            newLastTaken = lastTaken;
          }
        }
        
        final updatedMed = med.copyWith(
          history: newHistory,
          lastTaken: newLastTaken,
        );
        
        _medications[index] = updatedMed;
        notifyListeners();
      }
    }
  }

  // Appointments
  void addAppointment(Appointment appointment) {
    final newApt = appointment.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _appointments.add(newApt);
    notifyListeners();
  }
}
