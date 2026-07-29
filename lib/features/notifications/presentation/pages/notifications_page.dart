import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/theme/theme.dart';
import '../bloc/notifications_cubit.dart';
import '../bloc/notifications_state.dart';
import '../../data/models/notification_model.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    // Load notifications when page opens
    context.read<NotificationsCubit>().loadNotifications();
    // Mark all as read when opening the page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsCubit>().markAllAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Notifications',
          style: AppTypography.headingMedium.copyWith(fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white.withOpacity(0.1),
            height: 1,
          ),
        ),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is NotificationsError) {
            return Center(
              child: Text(
                state.message,
                style: AppTypography.bodyMedium.copyWith(color: Colors.red),
              ),
            );
          }

          if (state is NotificationsLoaded) {
            final notifications = state.notifications;
            
            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 64,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notifications yet',
                      style: AppTypography.headingSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'When you receive updates, they will appear here.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<NotificationsCubit>().loadNotifications(),
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              child: ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (context, index) => Divider(height: 1, color: Colors.white.withOpacity(0.1)),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationItem(notification);
                },
              ),
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    IconData icon;
    Color iconColor;
    Color bgColor;

    switch (notification.type) {
      case 'MESSAGE':
        icon = Icons.chat_bubble_outline;
        iconColor = AppColors.primary;
        bgColor = AppColors.primary.withOpacity(0.1);
        break;
      case 'PROPOSAL':
        icon = Icons.description_outlined;
        iconColor = Colors.orange;
        bgColor = Colors.orange.withOpacity(0.1);
        break;
      case 'CONTRACT':
        icon = Icons.handshake_outlined;
        iconColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.1);
        break;
      case 'PAYMENT':
        icon = Icons.payments_outlined;
        iconColor = Colors.purple;
        bgColor = Colors.purple.withOpacity(0.1);
        break;
      default:
        icon = Icons.notifications_none;
        iconColor = AppColors.textSecondary;
        bgColor = const Color(0xFFF3F4F6);
    }

    return Container(
      color: notification.isRead ? Colors.transparent : AppColors.primary.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: AppTypography.labelLarge.copyWith(
                          fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w800,
                          color: notification.isRead ? AppColors.textPrimary : Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeago.format(notification.createdAt),
                      style: AppTypography.bodySmall.copyWith(
                        color: notification.isRead ? Colors.grey : AppColors.primary,
                        fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
