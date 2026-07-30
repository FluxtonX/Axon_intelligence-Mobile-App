import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';

import '../../../../core/services/push_notification_service.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final SecureStorage _storage;
  final PushNotificationService? _pushNotificationService;

  AuthRepository(this._apiClient, this._storage, [this._pushNotificationService]);

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final accessToken = response.data['accessToken'];
      if (accessToken != null) {
        await _storage.saveToken(accessToken);
        await syncDeviceToken();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid credentials');
      }
      throw Exception('DioError: ${e.message} - ${e.error} - ${e.response?.data}');
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      final parts = name.split(' ');
      final firstName = parts.first;
      final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

      final response = await _apiClient.dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      });

      final accessToken = response.data['accessToken'];
      if (accessToken != null) {
        await _storage.saveToken(accessToken);
        await syncDeviceToken();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('Email already in use');
      }
      throw Exception(e.response?.data['message'] ?? 'An error occurred during registration');
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<String> forgotPassword(String email) async {
    try {
      final response = await _apiClient.dio.post('/auth/forgot-password', data: {
        'email': email,
      });
      return response.data['message'] ?? 'Password reset email sent';
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'An error occurred');
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _apiClient.dio.post('/auth/reset-password', data: {
        'token': token,
        'newPassword': newPassword,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'An error occurred during password reset');
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<void> logout() async {
    await _storage.clearAll();
  }

  bool isLoggedIn() {
    final token = _storage.getToken();
    return token != null && token.isNotEmpty;
  }

  bool hasSeenOnboarding() {
    return _storage.hasSeenOnboarding();
  }

  Future<void> setHasSeenOnboarding() async {
    await _storage.setHasSeenOnboarding();
  }

  Future<void> googleLogin(String idToken, {String? email, String? displayName, String? photoUrl}) async {
    try {
      final response = await _apiClient.dio.post('/auth/google', data: {
        'idToken': idToken,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
      });

      final accessToken = response.data['accessToken'];
      if (accessToken != null) {
        await _storage.saveToken(accessToken);
        await syncDeviceToken();
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Google authentication failed on server');
    } catch (e) {
      throw Exception('Failed to connect to server during Google login');
    }
  }



  Future<void> syncDeviceToken() async {
    if (_pushNotificationService != null) {
      final token = await _pushNotificationService?.getToken();
      if (token != null) {
        try {
          await _apiClient.dio.patch('/users/me/device-token', data: {'token': token});
        } catch (e) {
          print('Failed to upload device token: $e');
        }
      }
    }
  }
}
