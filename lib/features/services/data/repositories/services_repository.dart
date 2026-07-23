import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/service_entity.dart';

class ServicesRepository {
  final ApiClient _apiClient;

  ServicesRepository(this._apiClient);

  Future<ServiceEntity> createService({
    required String title,
    required String category,
    required String description,
    required double price,
    required int deliveryDays,
    String? imageUrl,
  }) async {
    try {
      final response = await _apiClient.dio.post('/services', data: {
        'title': title,
        'category': category,
        'description': description,
        'price': price,
        'deliveryDays': deliveryDays,
        if (imageUrl != null) 'imageUrl': imageUrl,
      });

      return ServiceEntity.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create service: $e');
    }
  }

  Future<List<ServiceEntity>> getServices({
    String? query,
    int skip = 0,
    int take = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get('/services', queryParameters: {
        if (query != null && query.isNotEmpty) 'q': query,
        'skip': skip,
        'take': take,
      });

      final List<dynamic> data = response.data;
      return data.map((json) => ServiceEntity.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load services: $e');
    }
  }

  Future<List<ServiceEntity>> getMyServices() async {
    try {
      final response = await _apiClient.dio.get('/services/me');
      final List<dynamic> data = response.data;
      return data.map((json) => ServiceEntity.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load your services: $e');
    }
  }
}
