class Suggest {
  final String id;
  final String name;
  final String comment;

  Suggest({
    required this.id,
    required this.name,
    required this.comment,
  });

  factory Suggest.fromMap(Map<String, dynamic> map) {
    return Suggest(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      comment: map['comment'] ?? '',
    );
  }
}
