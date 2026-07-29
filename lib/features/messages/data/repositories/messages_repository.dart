import '../../../../core/network/api_client.dart';
import '../../../../core/network/socket_client.dart';
import '../../../../core/storage/secure_storage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

class MessagesRepository {
  final ApiClient _apiClient;
  final SocketClient _socketClient;
  final SecureStorage _storage;
  
  final _messageStreamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get incomingMessages => _messageStreamController.stream;

  MessagesRepository(this._apiClient, this._socketClient, this._storage);

  /// Decodes JWT to get the user ID
  String? _getUserIdFromToken() {
    final token = _storage.getToken();
    if (token == null) return null;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final data = json.decode(payload);
      return data['sub']; // userId
    } catch (e) {
      return null;
    }
  }

  void initializeSocket() {
    final userId = _getUserIdFromToken();
    final token = _storage.getToken();
    if (userId != null && token != null) {
      _socketClient.connect(token);
      
      // Listen for real-time messages from the backend
      _socketClient.on('messageToUser-$userId', (data) {
        if (data != null) {
          final message = Map<String, dynamic>.from(data);
          // Broadcast to the UI Blocs
          _messageStreamController.add(message);
        }
      });
    }
  }

  void dispose() {
    _messageStreamController.close();
  }

  Future<List<dynamic>> getConversations() async {
    try {
      final response = await _apiClient.dio.get('/messages');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to load conversations: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> getConversation(String otherUserId, {int page = 1}) async {
    try {
      final response = await _apiClient.dio.get(
        '/messages/conversation/$otherUserId',
        queryParameters: {'page': page},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to load conversation: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> sendMessage(String receiverId, String content, {String senderRole = 'client'}) async {
    try {
      await _apiClient.dio.post(
        '/messages',
        data: {'receiverId': receiverId, 'content': content},
      );
    } on DioException catch (e) {
      throw Exception('Failed to send message: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> markAsRead(String messageId) async {
    try {
      await _apiClient.dio.patch('/messages/$messageId/read');
    } on DioException catch (e) {
      throw Exception('Failed to mark message as read: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
