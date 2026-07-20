import '../../../../core/network/api_client.dart';
import '../models/contract_model.dart';
import '../../domain/entities/contract_entity.dart';

class ContractRepository {
  final ApiClient _apiClient;

  ContractRepository(this._apiClient);

  Future<void> fundContract(String contractId) async {
    try {
      await _apiClient.dio.post('/contracts/$contractId/fund');
    } catch (e) {
      throw Exception('Failed to fund contract: $e');
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

  Future<void> submitWork(String contractId, String submissionDetails) async {
    try {
      await _apiClient.dio.post(
        '/contracts/$contractId/submit',
        data: {'submissionDetails': submissionDetails},
      );
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
