import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _storage;
  
  String? _cachedToken;
  String? _cachedRefreshToken;

  SecureStorage._internal(this._storage);

  static Future<SecureStorage> init() async {
    const storage = FlutterSecureStorage();
    final instance = SecureStorage._internal(storage);
    
    // Pre-load tokens for synchronous access
    instance._cachedToken = await storage.read(key: _tokenKey);
    instance._cachedRefreshToken = await storage.read(key: _refreshTokenKey);
    
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
}
