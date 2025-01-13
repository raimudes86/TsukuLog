class Lesson {
  final String id;
  final String name;
  final String comment;

  Lesson({
    required this.id,
    required this.name,
    required this.comment,
  });

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      comment: map['comment'] ?? '',
    );
  }
}
