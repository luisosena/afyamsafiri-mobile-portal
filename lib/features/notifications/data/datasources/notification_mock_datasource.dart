import '../models/notification.dart';

class NotificationMockDataSource {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'notif-001',
      'title': 'Booking Confirmed',
      'message': 'Your arrival booking AMS-2026-001 has been confirmed.',
      'type': 'bookingConfirmed',
      'isRead': false,
      'createdAt': '2026-08-20T10:05:00Z',
    },
    {
      'id': 'notif-002',
      'title': 'Health Screening Required',
      'message': 'Please complete your health screening before arrival.',
      'type': 'actionRequired',
      'isRead': false,
      'createdAt': '2026-08-21T08:00:00Z',
    },
    {
      'id': 'notif-003',
      'title': 'Arrival Reminder',
      'message': 'Your arrival at Julius Nyerere International Airport is in 3 days.',
      'type': 'arrivalReminder',
      'isRead': true,
      'createdAt': '2026-08-28T09:00:00Z',
    },
  ];

  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _notifications.map((n) => NotificationModel.fromJson(n)).toList();
  }

  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      _notifications[index]['isRead'] = true;
    }
  }

  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (final n in _notifications) {
      n['isRead'] = true;
    }
  }

  Future<int> getUnreadCount() async {
    return _notifications.where((n) => n['isRead'] == false).length;
  }
}