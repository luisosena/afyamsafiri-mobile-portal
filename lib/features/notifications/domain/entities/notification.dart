enum NotificationType {
  actionRequired,
  bookingConfirmed,
  arrivalReminder,
  general,
}

class AppNotification {
  const AppNotification({
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
  final NotificationType type;
  final bool isRead;
  final DateTime? createdAt;

  AppNotification markAsRead() {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      type: type,
      isRead: true,
      createdAt: createdAt,
    );
  }
}