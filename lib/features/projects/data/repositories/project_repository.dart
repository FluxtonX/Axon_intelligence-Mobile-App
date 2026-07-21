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
      final responseData = response.data;
      List data = [];
      if (responseData is List) {
        data = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        data = responseData['data'];
      }
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

  Future<ProjectModel> updateProject(String id, {
    String? title,
    String? description,
    double? budget,
    String? timeline,
    List<String>? skills,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (budget != null) data['budget'] = budget;
      if (timeline != null) data['timeline'] = timeline;
      if (skills != null) data['skills'] = skills;
      
      final response = await _apiClient.dio.patch('/projects/$id', data: data);
      return ProjectModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update project: $e');
    }
  }

  Future<List<ProjectModel>> getAvailableProjects({int page = 1, int limit = 10}) async {
    try {
      final response = await _apiClient.dio.get(
        '/projects',
        queryParameters: {'page': page, 'limit': limit},
      );
      final responseData = response.data;
      List data = [];
      if (responseData is List) {
        data = responseData;
      } else if (responseData is Map) {
        if (responseData['projects'] is List) {
          data = responseData['projects'];
        } else if (responseData['data'] is List) {
          data = responseData['data'];
        }
      }
      return data.map((json) => ProjectModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load available projects: $e');
    }
  }
}
