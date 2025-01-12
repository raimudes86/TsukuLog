class CareerHistory {
  final String id;
  final String title;
  final String category;
  final String startGrade;
  final int startMonth;
  final String span;
  final int difficultLevel;
  final int recommendLevel;
  final String reason;
  final String comment;

  CareerHistory({
    this.id = '',
    this.title = '',
    this.category = '',
    this.startGrade = '',
    this.startMonth = 0,
    this.span = '',
    this.difficultLevel = 0,
    this.recommendLevel = 0,
    this.reason = '',
    this.comment = '',
  });

  factory CareerHistory.fromMap(Map<String, dynamic> map) {
    return CareerHistory(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      startGrade: map['start_grade'] ?? '',
      startMonth: map['start_month'] ?? 0,
      span: map['span'] ?? '',
      difficultLevel: map['difficult_level'] ?? 0,
      recommendLevel: map['recommend_level'] ?? 0,
      reason: map['reason'] ?? '',
      comment: map['comment'] ?? '',
    );
  }
}
