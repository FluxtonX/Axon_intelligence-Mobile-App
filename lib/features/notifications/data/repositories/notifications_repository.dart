import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/notification_model.dart';

class NotificationsRepository {
  final ApiClient _apiClient;

  NotificationsRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _apiClient.dio.get('/notifications');
      final List<dynamic> data = response.data;
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? 'Failed to load notifications');
      }
      throw Exception('Failed to load notifications');
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.dio.get('/notifications/unread-count');
      return response.data['count'] ?? 0;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? 'Failed to get unread count');
      }
      throw Exception('Failed to get unread count');
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _apiClient.dio.patch('/notifications/$id/read');
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? 'Failed to mark as read');
      }
      throw Exception('Failed to mark as read');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _apiClient.dio.patch('/notifications/read-all');
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? 'Failed to mark all as read');
      }
      throw Exception('Failed to mark all as read');
    }
  }
}
