import '../models/notification.dart';

class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications() async {
    throw UnimplementedError('Remote API not yet available');
  }

  Future<void> markAsRead(String notificationId) async {
    throw UnimplementedError('Remote API not yet available');
  }

  Future<void> markAllAsRead() async {
    throw UnimplementedError('Remote API not yet available');
  }

  Future<int> getUnreadCount() async {
    throw UnimplementedError('Remote API not yet available');
  }
}