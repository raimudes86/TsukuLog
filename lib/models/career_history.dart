class CareerHistory {
  final String title;
  final String category;
  final String startDate;
  final String span;
  final int difficultLevel;
  final int recommendLevel;
  final String reason;
  final String comment;

  CareerHistory({
    required this.title,
    required this.category,
    required this.startDate,
    required this.span,
    required this.difficultLevel,
    required this.recommendLevel,
    required this.reason,
    required this.comment,
  });

  factory CareerHistory.fromMap(Map<String, dynamic> map) {
    return CareerHistory(
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      startDate: map['start_date'] ?? '',
      span: map['span'] ?? '',
      difficultLevel: map['difficult_level'] ?? 0,
      recommendLevel: map['recommend_level'] ?? 0,
      reason: map['reason'] ?? '',
      comment: map['comment'] ?? '',
    );
  }
}
