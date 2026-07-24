import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class ReviewsRepository {
  final ApiClient _apiClient;

  ReviewsRepository(this._apiClient);

  Future<void> createReview(String contractId, String revieweeId, int rating, String comment) async {
    try {
      await _apiClient.dio.post(
        '/reviews',
        data: {
          'contractId': contractId,
          'revieweeId': revieweeId,
          'rating': rating,
          'comment': comment,
        },
      );
    } on DioException catch (e) {
      final errorMsg = e.response?.data != null ? e.response?.data.toString() : e.message;
      throw Exception('Failed to create review: $errorMsg');
    } catch (e) {
      throw Exception('Failed to create review: $e');
    }
  }

  Future<List<dynamic>> getReviewsForUser(String userId) async {
    try {
      final response = await _apiClient.dio.get('/reviews/user/$userId');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get reviews: $e');
    }
  }
}
