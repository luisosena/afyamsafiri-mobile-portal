import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/notification_provider.dart';
import '../widgets/notifications_list.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: AppColors.surfaceGray,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: AppTextStyles.heading1.copyWith(
            fontSize: 20,
            color: AppColors.deepSlate,
          ),
        ),

        actions: [
          if (provider.unreadCount > 0)
            TextButton(
              onPressed: () => provider.markAllAsRead(),
              child: Text(
                'Mark all read',
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
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(NotificationProvider provider) {
    switch (provider.status) {
      case NotificationStatus.initial:
      case NotificationStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        );
      case NotificationStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.urgentRed),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Failed to load notifications',
                style: AppTextStyles.body.copyWith(color: AppColors.deepSlate),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => provider.loadNotifications(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      case NotificationStatus.loaded:
        if (provider.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  size: 64,
                  color: AppColors.textMuted,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'No notifications yet',
                  style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          );
        }
        return NotificationsList(
          notifications: provider.notifications,
          onItemTap: (notification) {
            if (!notification.isRead) {
              provider.markAsRead(notification.id);
            }
          },
          onMarkAllAsRead: () => provider.markAllAsRead(),
        );
    }
  }
}
