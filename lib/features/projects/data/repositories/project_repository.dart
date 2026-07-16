import '../../../../core/models/project_model.dart';
import '../../../../core/network/api_client.dart';

class ProjectRepository {
  final ApiClient _apiClient;

  ProjectRepository(this._apiClient);

  Future<List<ProjectModel>> getMyProjects({int page = 1, int limit = 10}) async {
    try {
      final response = await _apiClient.dio.get(
        '/projects/me',
        queryParameters: {'page': page, 'limit': limit},
      );
      final List data = response.data['data'];
      return data.map((json) => ProjectModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load projects: $e');
    }
  }

  Future<ProjectModel> createProject({
    required String title,
    required String description,
    required double budget,
    String? timeline,
    List<String> skills = const [],
  }) async {
    try {
      final response = await _apiClient.dio.post('/projects', data: {
        'title': title,
        'description': description,
        'budget': budget,
        'timeline': timeline,
        'skills': skills,
      });
      return ProjectModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create project: $e');
    }
  }

  Future<List<ProjectModel>> getAvailableProjects({int page = 1, int limit = 10}) async {
    try {
      final response = await _apiClient.dio.get(
        '/projects',
        queryParameters: {'page': page, 'limit': limit},
      );
      final List data = response.data['data'];
      return data.map((json) => ProjectModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load available projects: $e');
    }
  }
}
