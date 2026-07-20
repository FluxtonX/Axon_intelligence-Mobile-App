import '../../../../core/network/api_client.dart';
import '../../domain/entities/proposal_entity.dart';

class ProposalRepository {
  final ApiClient _apiClient;

  ProposalRepository(this._apiClient);

  Future<void> submitProposal({
    required String projectId,
    required double bidAmount,
    required int deliveryDays,
    required String coverLetter,
  }) async {
    try {
      await _apiClient.dio.post('/proposals', data: {
        'projectId': projectId,
        'bidAmount': bidAmount,
        'deliveryDays': deliveryDays,
        'coverLetter': coverLetter,
      });
    } catch (e) {
      throw Exception('Failed to submit proposal: $e');
    }
  }

  Future<List<ProposalEntity>> getProposalsForProject(String projectId) async {
    try {
      final response = await _apiClient.dio.get('/proposals/project/$projectId');
      final List data = response.data;
      return data.map((json) => ProposalEntity.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get proposals: $e');
    }
  }

  Future<String> acceptProposal(String proposalId) async {
    try {
      final response = await _apiClient.dio.patch('/proposals/$proposalId/accept');
      return response.data['id'] as String;
    } catch (e) {
      throw Exception('Failed to accept proposal: $e');
    }
  }
}
