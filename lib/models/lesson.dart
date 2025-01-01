class Lesson {
  final String name;
  final String comment;

  Lesson({
    required this.name,
    required this.comment,
  });

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      name: map['name'] ?? '',
      comment: map['comment'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'comment': comment,
    };
  }
}
