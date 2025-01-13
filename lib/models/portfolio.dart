class PortFolio {
  final String id;
  final String name;
  final String comment;

  PortFolio({
    required this.id,
    required this.name,
    required this.comment,
  });

  factory PortFolio.fromMap(Map<String, dynamic> map) {
    return PortFolio(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      comment: map['comment'] ?? '',
    );
  }
}
