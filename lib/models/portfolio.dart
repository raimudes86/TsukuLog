class PortFolio {
  final String name;
  final String comment;

  PortFolio({
    required this.name,
    required this.comment,
  });

  factory PortFolio.fromMap(Map<String, dynamic> map) {
    return PortFolio(
      name: map['name'] ?? '',
      comment: map['comment'] ?? '',
    );
  }
}
