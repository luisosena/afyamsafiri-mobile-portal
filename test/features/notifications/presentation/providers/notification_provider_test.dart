import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afyamsafiri/features/notifications/domain/entities/notification.dart';
import 'package:afyamsafiri/features/notifications/domain/repositories/notification_repository.dart';
import 'package:afyamsafiri/features/notifications/presentation/providers/notification_provider.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  late MockNotificationRepository mockRepo;
  late NotificationProvider provider;

  final testNotifications = [
    AppNotification(
      id: 'n1',
      title: 'Booking Submitted',
      message: 'Your form has been submitted.',
      type: NotificationType.bookingSubmitted,
      isRead: false,
      createdAt: DateTime(2026, 8, 20),
    ),
    AppNotification(
      id: 'n2',
      title: 'Arrival Reminder',
      message: 'Your arrival is in 3 days.',
      type: NotificationType.arrivalReminder,
      isRead: true,
      createdAt: DateTime(2026, 8, 28),
    ),
  ];

  setUp(() {
    mockRepo = MockNotificationRepository();
    provider = NotificationProvider(notificationRepository: mockRepo);
  });

  group('NotificationProvider', () {
    test('initial state is correct', () {
      expect(provider.status, NotificationStatus.initial);
      expect(provider.notifications, isEmpty);
      expect(provider.unreadCount, 0);
      expect(provider.errorMessage, isNull);
    });

    group('loadNotifications', () {
      test('loads notifications and unread count on success', () async {
        when(() => mockRepo.getNotifications())
            .thenAnswer((_) async => testNotifications);
        when(() => mockRepo.getUnreadCount()).thenAnswer((_) async => 1);

        await provider.loadNotifications();

        expect(provider.status, NotificationStatus.loaded);
        expect(provider.notifications.length, 2);
        expect(provider.unreadCount, 1);
      });

      test('sets error on failure', () async {
        when(() => mockRepo.getNotifications())
            .thenThrow(Exception('network error'));

        await provider.loadNotifications();

        expect(provider.status, NotificationStatus.error);
        expect(provider.errorMessage, isNotNull);
      });

      test('transitions through loading state', () async {
        final statuses = <NotificationStatus>[];
        provider.addListener(() => statuses.add(provider.status));

        when(() => mockRepo.getNotifications())
            .thenAnswer((_) async => testNotifications);
        when(() => mockRepo.getUnreadCount()).thenAnswer((_) async => 1);

        await provider.loadNotifications();

        expect(statuses, [NotificationStatus.loading, NotificationStatus.loaded]);
      });
    });

    group('markAsRead', () {
      test('marks specific notification as read', () async {
        when(() => mockRepo.getNotifications())
            .thenAnswer((_) async => testNotifications);
        when(() => mockRepo.getUnreadCount()).thenAnswer((_) async => 1);
        when(() => mockRepo.markAsRead(any())).thenAnswer((_) async {});

        await provider.loadNotifications();
        await provider.markAsRead('n1');

        final n1 = provider.notifications.firstWhere((n) => n.id == 'n1');
        expect(n1.isRead, isTrue);
        expect(provider.unreadCount, 0);
      });

      test('sets error on failure', () async {
        when(() => mockRepo.getNotifications())
            .thenAnswer((_) async => testNotifications);
        when(() => mockRepo.getUnreadCount()).thenAnswer((_) async => 1);
        when(() => mockRepo.markAsRead(any()))
            .thenThrow(Exception('mark failed'));

        await provider.loadNotifications();
        await provider.markAsRead('n1');

        expect(provider.errorMessage, isNotNull);
      });
    });

    group('markAllAsRead', () {
      test('marks all notifications as read', () async {
        when(() => mockRepo.getNotifications())
            .thenAnswer((_) async => testNotifications);
        when(() => mockRepo.getUnreadCount()).thenAnswer((_) async => 1);
        when(() => mockRepo.markAllAsRead()).thenAnswer((_) async {});

        await provider.loadNotifications();
        await provider.markAllAsRead();

        expect(provider.notifications.every((n) => n.isRead), isTrue);
        expect(provider.unreadCount, 0);
      });
    });

    group('unreadNotifications', () {
      test('returns only unread notifications', () async {
        when(() => mockRepo.getNotifications())
            .thenAnswer((_) async => testNotifications);
        when(() => mockRepo.getUnreadCount()).thenAnswer((_) async => 1);

        await provider.loadNotifications();

        expect(provider.unreadNotifications.length, 1);
        expect(provider.unreadNotifications.first.id, 'n1');
      });
    });
  });
}
