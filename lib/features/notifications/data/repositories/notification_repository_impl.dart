import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_mock_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required this.remoteDataSource,
  });

  final NotificationMockDataSource remoteDataSource;

  @override
  Future<List<AppNotification>> getNotifications() async {
    final models = await remoteDataSource.getNotifications();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await remoteDataSource.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead() async {
    await remoteDataSource.markAllAsRead();
  }

  @override
  Future<int> getUnreadCount() async {
    return remoteDataSource.getUnreadCount();
  }
}