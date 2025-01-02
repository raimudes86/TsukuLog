class Qualification {
  final String name;
  final String year;

  Qualification({
    required this.name,
    required this.year,
  });

  factory Qualification.fromMap(Map<String, dynamic> map) {
    return Qualification(
      name: map['name'] ?? '',
      year: map['year'] ?? '',
    );
  }
}
