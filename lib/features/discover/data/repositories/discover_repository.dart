import '../../../../core/models/user_model.dart';
import '../../../../core/network/api_client.dart';

class DiscoverRepository {
  final ApiClient _apiClient;

  DiscoverRepository(this._apiClient);

  Future<List<UserModel>> searchFreelancers({
    String? query,
    double? maxHourlyRate,
    double? minRating,
    String? category,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (query != null && query.isNotEmpty) {
        queryParams['q'] = query;
      }
      if (maxHourlyRate != null) {
        queryParams['maxHourlyRate'] = maxHourlyRate;
      }
      if (minRating != null) {
        queryParams['minRating'] = minRating;
      }
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      final response = await _apiClient.dio.get(
        '/users/freelancers',
        queryParameters: queryParams,
      );

      final data = response.data['data'] as List;
      return data.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search freelancers: $e');
    }
  }
}
