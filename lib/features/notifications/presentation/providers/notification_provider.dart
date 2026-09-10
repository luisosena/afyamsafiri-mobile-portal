import 'package:flutter/material.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';

enum NotificationStatus { initial, loading, loaded, error }

class NotificationProvider extends ChangeNotifier {
  NotificationProvider({required NotificationRepository notificationRepository})
      : _repository = notificationRepository;

  final NotificationRepository _repository;

  List<AppNotification> _notifications = [];
  NotificationStatus _status = NotificationStatus.initial;
  String? _errorMessage;
  int _unreadCount = 0;

  List<AppNotification> get notifications => _notifications;
  NotificationStatus get status => _status;
  String? get errorMessage => _errorMessage;
  int get unreadCount => _unreadCount;

  List<AppNotification> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  Future<void> loadNotifications() async {
    _status = NotificationStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _repository.getNotifications();
      _unreadCount = await _repository.getUnreadCount();
      _status = NotificationStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = NotificationStatus.error;
    }
    notifyListeners();
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _repository.markAsRead(notificationId);
      _notifications = _notifications.map((n) {
        return n.id == notificationId ? n.markAsRead() : n;
      }).toList();
      _unreadCount = _notifications.where((n) => !n.isRead).length;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _repository.markAllAsRead();
      _notifications = _notifications.map((n) => n.markAsRead()).toList();
      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
