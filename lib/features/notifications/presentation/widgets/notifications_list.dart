import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/notification.dart';
import 'notification_item.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({
    super.key,
    required this.notifications,
    this.onItemTap,
    this.onMarkAllAsRead,
  });

  final List<AppNotification> notifications;
  final ValueChanged<AppNotification>? onItemTap;
  final VoidCallback? onMarkAllAsRead;

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Column(
      children: [
        if (unreadCount > 0)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.containerPadding,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Text(
                  '$unreadCount unread',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onMarkAllAsRead,
                  child: Text(
                    'Mark all as read',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationItem(
                notification: notification,
                onTap: () => onItemTap?.call(notification),
              );
            },
          ),
        ),
      ],
    );
  }
}
