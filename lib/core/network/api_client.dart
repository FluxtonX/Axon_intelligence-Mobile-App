import 'package:dio/dio.dart';
import '../storage/local_storage.dart';

class ApiClient {
  final Dio _dio;
  final LocalStorage _storage;

  // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web/Windows
  // Since user might run on Windows/Web, we'll use localhost.
  static const String baseUrl = 'http://localhost:3000/api';

  ApiClient(this._storage) : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }
  )) {
    _setupInterceptors();
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Can handle global 401 refresh token logic here if needed
          return handler.next(e);
        },
      ),
    );
  }
}
