class PointOfEntry {
  const PointOfEntry({
    required this.id,
    required this.name,
    required this.type,
    this.location,
  });

  final String id;
  final String name;
  final String type;
  final String? location;
}