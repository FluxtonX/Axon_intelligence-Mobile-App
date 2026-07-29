import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/notifications_repository.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsCubit({required NotificationsRepository repository})
      : _repository = repository,
        super(NotificationsInitial());

  Future<void> loadNotifications() async {
    try {
      emit(NotificationsLoading());
      final notifications = await _repository.getNotifications();
      final unreadCount = await _repository.getUnreadCount();
      emit(NotificationsLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> refreshUnreadCount() async {
    if (state is NotificationsLoaded) {
      try {
        final count = await _repository.getUnreadCount();
        final currentState = state as NotificationsLoaded;
        emit(NotificationsLoaded(
          notifications: currentState.notifications,
          unreadCount: count,
        ));
      } catch (e) {
        // Silently fail on background refresh
      }
    } else {
      try {
        final count = await _repository.getUnreadCount();
        emit(NotificationsLoaded(
          notifications: const [],
          unreadCount: count,
        ));
      } catch (e) {
        // Silently fail
      }
    }
  }

  Future<void> markAllAsRead() async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      try {
        await _repository.markAllAsRead();
        // Optimistically update UI
        final updatedNotifications = currentState.notifications.map((n) {
          return n.isRead ? n : n; // No copyWith method so we just wait for reload, but wait we can just reload
        }).toList();
        
        emit(NotificationsLoaded(
          notifications: updatedNotifications, // We actually just reload for simplicity
          unreadCount: 0,
        ));
        
        // Reload properly
        await loadNotifications();
      } catch (e) {
        emit(NotificationsError(e.toString()));
      }
    }
  }
}
