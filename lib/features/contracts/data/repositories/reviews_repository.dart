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
      String errorMessage = 'A network error occurred. Please try again.';
      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? e.response?.data['error'] ?? 'Failed to submit review.';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred while submitting your review.');
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
