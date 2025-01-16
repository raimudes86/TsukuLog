class PortFolio {
  final String id;
  final String name;
  final String link;
  final String comment;

  PortFolio({
    required this.id,
    required this.name,
    required this.link,
    required this.comment,
  });

  factory PortFolio.fromMap(Map<String, dynamic> map) {
    return PortFolio(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      link: map['link'] ?? '',
      comment: map['comment'] ?? '',
    );
  }
}
