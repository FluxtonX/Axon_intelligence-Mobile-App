import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _onboardingKey = 'has_seen_onboarding';

  final FlutterSecureStorage _storage;
  
  String? _cachedToken;
  String? _cachedRefreshToken;
  bool _cachedHasSeenOnboarding = false;

  SecureStorage._internal(this._storage);

  static Future<SecureStorage> init() async {
    const storage = FlutterSecureStorage();
    final instance = SecureStorage._internal(storage);
    
    // Pre-load tokens for synchronous access
    instance._cachedToken = await storage.read(key: _tokenKey);
    instance._cachedRefreshToken = await storage.read(key: _refreshTokenKey);
    final onboardingValue = await storage.read(key: _onboardingKey);
    instance._cachedHasSeenOnboarding = onboardingValue == 'true';
    
    return instance;
  }

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _storage.write(key: _tokenKey, value: token);
  }

  String? getToken() {
    return _cachedToken;
  }

  Future<void> saveRefreshToken(String token) async {
    _cachedRefreshToken = token;
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  String? getRefreshToken() {
    return _cachedRefreshToken;
  }

  Future<void> clearAll() async {
    _cachedToken = null;
    _cachedRefreshToken = null;
    await _storage.deleteAll();
  }

  bool hasSeenOnboarding() {
    return _cachedHasSeenOnboarding;
  }

  Future<void> setHasSeenOnboarding() async {
    _cachedHasSeenOnboarding = true;
    await _storage.write(key: _onboardingKey, value: 'true');
  }
}
