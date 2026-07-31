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

  Future<ContractEntity> getContractById(String id) async {
    try {
      final response = await _apiClient.dio.get('/contracts/$id');
      return ContractModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch contract by ID: $e');
    }
  }

  Future<void> submitWork(
    String contractId, 
    String submissionDetails, {
    List<int>? fileBytes,
    String? fileName,
  }) async {
    try {
      final formData = FormData.fromMap({
        'submissionDetails': submissionDetails,
      });

      if (fileBytes != null && fileName != null) {
        formData.files.add(MapEntry(
          'file',
          MultipartFile.fromBytes(fileBytes, filename: fileName),
        ));
      }

      await _apiClient.dio.post(
        '/contracts/$contractId/submit',
        data: formData,
      );
    } on DioException catch (e) {
      String errorMessage = 'A network error occurred. Please try again.';
      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? e.response?.data['error'] ?? 'Failed to submit work.';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred while submitting work.');
    }
  }

  Future<void> requestRevision(String contractId, String notes) async {
    try {
      await _apiClient.dio.post(
        '/contracts/$contractId/revision',
        data: { 'notes': notes },
      );
    } on DioException catch (e) {
      String errorMessage = 'A network error occurred. Please try again.';
      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? e.response?.data['error'] ?? 'Failed to request revision.';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred while requesting revision.');
    }
  }

  Future<void> approveWork(String contractId) async {
    try {
      await _apiClient.dio.post('/contracts/$contractId/complete');
    } on DioException catch (e) {
      String errorMessage = 'A network error occurred. Please try again.';
      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? e.response?.data['error'] ?? 'Failed to approve work.';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred while approving work.');
    }
  }
}
