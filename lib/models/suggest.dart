class Suggest {
  final String name;
  final String comment;

  Suggest({
    required this.name,
    required this.comment,
  });

  factory Suggest.fromMap(Map<String, dynamic> map) {
    return Suggest(
      name: map['name'] ?? '',
      comment: map['comment'] ?? '',
    );
  }
}
