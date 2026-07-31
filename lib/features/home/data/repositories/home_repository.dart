import '../../../../core/network/api_client.dart';
import '../models/dashboard_data_model.dart';

class HomeRepository {
  final ApiClient _apiClient;

  HomeRepository(this._apiClient);

  Future<DashboardDataModel> getClientDashboard() async {
    try {
      final response = await _apiClient.dio.get('/users/me/client-dashboard');
      return DashboardDataModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load dashboard data: $e');
    }
  }
}
