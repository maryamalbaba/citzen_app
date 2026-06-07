// tokenStorage.dart


// secureTokenStorage.dart
import 'package:citzenapp/core/service/Token/tokenStorage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage storage;

  SecureTokenStorage(this.storage);

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  @override
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await storage.write(key: _accessTokenKey, value: accessToken);
    await storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  @override
  Future<String?> getAccessToken() async {
    return await storage.read(key: _accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await storage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> clearTokens() async {
    await storage.delete(key: _accessTokenKey);
    await storage.delete(key: _refreshTokenKey);
  }
}