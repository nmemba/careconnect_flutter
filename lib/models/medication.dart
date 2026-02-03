class Medication {
  final String id;
  final String name;
  final String dose;
  final String frequency;
  final List<String> times;
  final int refillsRemaining;
  final String pharmacy;
  final MedicationAction? lastTaken;
  final List<MedicationAction> history;

  Medication({
    required this.id,
    required this.name,
    required this.dose,
    required this.frequency,
    required this.times,
    required this.refillsRemaining,
    required this.pharmacy,
    this.lastTaken,
    required this.history,
  });

  Medication copyWith({
    String? id,
    String? name,
    String? dose,
    String? frequency,
    List<String>? times,
    int? refillsRemaining,
    String? pharmacy,
    MedicationAction? lastTaken,
    List<MedicationAction>? history,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      frequency: frequency ?? this.frequency,
      times: times ?? this.times,
      refillsRemaining: refillsRemaining ?? this.refillsRemaining,
      pharmacy: pharmacy ?? this.pharmacy,
      lastTaken: lastTaken ?? this.lastTaken,
      history: history ?? this.history,
    );
  }
}

class MedicationAction {
  final DateTime timestamp;
  final String user;
  final String action; // 'taken' or 'skipped'

  MedicationAction({
    required this.timestamp,
    required this.user,
    this.action = 'taken',
  });
}
