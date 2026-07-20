import '../../../../core/network/api_client.dart';

class MessagesRepository {
  final ApiClient _apiClient;

  MessagesRepository(this._apiClient);

  Future<List<dynamic>> getConversations() async {
    try {
      final response = await _apiClient.dio.get('/messages');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get conversations: $e');
    }
  }

  Future<Map<String, dynamic>> getConversation(String otherUserId, {int page = 1}) async {
    try {
      final response = await _apiClient.dio.get(
        '/messages/conversation/$otherUserId',
        queryParameters: {'page': page},
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to get conversation: $e');
    }
  }

  Future<void> sendMessage(String receiverId, String content) async {
    try {
      await _apiClient.dio.post(
        '/messages',
        data: {'receiverId': receiverId, 'content': content},
      );
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<void> markAsRead(String messageId) async {
    try {
      await _apiClient.dio.patch('/messages/$messageId/read');
    } catch (e) {
      throw Exception('Failed to mark message as read: $e');
    }
  }
}
