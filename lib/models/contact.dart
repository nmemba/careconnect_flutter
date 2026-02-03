class Contact {
  final String id;
  final String name;
  final String role;
  final String? phone;

  Contact({
    required this.id,
    required this.name,
    required this.role,
    this.phone,
  });
}
