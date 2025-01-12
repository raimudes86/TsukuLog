class Qualification {
  final String id;
  final String name;
  final String year;

  Qualification({
    required this.id,
    required this.name,
    required this.year,
  });

  factory Qualification.fromMap(Map<String, dynamic> map) {
    return Qualification(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      year: map['year'] ?? '',
    );
  }
}
