class Club {
  final String id;
  final String name;
  final String comment;

  Club({
    required this.id,
    required this.name,
    required this.comment,
  });

  factory Club.fromMap(Map<String, dynamic> map) {
    return Club(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      comment: map['comment'] ?? '',
    );
  }
}
