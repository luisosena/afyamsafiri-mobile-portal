import '../../domain/entities/notification.dart';

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    this.createdAt,
  });

  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String? createdAt;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
    );
  }

  AppNotification toEntity() {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      type: NotificationType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => NotificationType.general,
      ),
      isRead: isRead,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
    );
  }
}