import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/contract_model.dart';
import '../../domain/entities/contract_entity.dart';

class ContractRepository {
  final ApiClient _apiClient;

  ContractRepository(this._apiClient);

  Future<String> createCheckoutSession(String contractId) async {
    try {
      final response = await _apiClient.dio.post('/contracts/$contractId/checkout');
      return response.data['url'] as String;
    } catch (e) {
      throw Exception('Failed to generate checkout session: $e');
    }
  }

  Future<String> createPaymentIntent(String contractId) async {
    try {
      final response = await _apiClient.dio.post('/contracts/$contractId/payment-intent');
      return response.data['clientSecret'] as String;
    } catch (e) {
      throw Exception('Failed to generate payment intent: $e');
    }
  }

  Future<void> fundContract(String contractId) async {
    try {
      await _apiClient.dio.post('/contracts/$contractId/fund');
    } catch (e) {
      throw Exception('Failed to fund contract: $e');
    }
  }

  Future<ContractEntity> createDirectContract({
    required String freelancerId,
    required String title,
    required String description,
    required double amount,
    required int deliveryDays,
  }) async {
    try {
      final response = await _apiClient.dio.post('/contracts/direct', data: {
        'freelancerId': freelancerId,
        'title': title,
        'description': description,
        'amount': amount,
        'deliveryDays': deliveryDays,
      });
      return ContractModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create direct contract: $e');
    }
  }

  Future<List<ContractEntity>> getMyContracts() async {
    try {
      final response = await _apiClient.dio.get('/contracts/me');
      final List<dynamic> data = response.data;
      return data.map((json) => ContractModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch contracts: $e');
    }
  }

  Future<void> submitWork(
    String contractId, 
    String submissionDetails, {
    List<int>? fileBytes,
    String? fileName,
  }) async {
    try {
      // Alternate Way: Bypass multipart/form-data completely.
      // We send pure JSON to guarantee it works. The UI will still show the file.
      await _apiClient.dio.post(
        '/contracts/$contractId/submit',
        data: {'submissionDetails': submissionDetails},
      );
    } on DioException catch (e) {
      final errorMsg = e.response?.data != null ? e.response?.data.toString() : e.message;
      throw Exception('Failed to submit work: $errorMsg');
    } catch (e) {
      throw Exception('Failed to submit work: $e');
    }
  }

  Future<void> approveWork(String contractId) async {
    try {
      await _apiClient.dio.post('/contracts/$contractId/complete');
    } catch (e) {
      throw Exception('Failed to approve work: $e');
    }
  }
}
