import '../../../../core/network/api_client.dart';

class AiProjectRepository {
  final ApiClient _apiClient;

  AiProjectRepository(this._apiClient);

  Future<Map<String, dynamic>> sendChatMessage(int step, String message) async {
    try {
      final response = await _apiClient.dio.post(
        '/projects/ai/chat',
        data: {'step': step, 'message': message},
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to communicate with AI: $e');
    }
  }
}
