class Appointment {
  final String id;
  final String title;
  final DateTime date;
  final String time;
  final String location;
  final String provider;

  Appointment({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.provider,
  });

  Appointment copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? time,
    String? location,
    String? provider,
  }) {
    return Appointment(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      provider: provider ?? this.provider,
    );
  }
}
