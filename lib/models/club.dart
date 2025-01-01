class Club {
  final String name;
  final String comment;

  Club({
    required this.name,
    required this.comment,
  });

  factory Club.fromMap(Map<String, dynamic> map) {
    return Club(
      name: map['name'] ?? '',
      comment: map['comment'] ?? '',
    );
  }
}
