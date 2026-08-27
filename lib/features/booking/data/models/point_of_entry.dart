import '../../domain/entities/point_of_entry.dart';

class PointOfEntryModel {
  const PointOfEntryModel({
    required this.id,
    required this.name,
    required this.type,
    this.location,
  });

  final String id;
  final String name;
  final String type;
  final String? location;

  factory PointOfEntryModel.fromJson(Map<String, dynamic> json) {
    return PointOfEntryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      location: json['location'] as String?,
    );
  }

  PointOfEntry toEntity() {
    return PointOfEntry(
      id: id,
      name: name,
      type: type,
      location: location,
    );
  }
}