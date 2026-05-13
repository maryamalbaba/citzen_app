import 'package:citzenapp/core/service/Token/tokenStorage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class SecureTokenStorage
    implements TokenStorage {

  final FlutterSecureStorage storage;

  SecureTokenStorage(this.storage);

  static const _tokenKey = 'token';

  @override
  Future<void> saveToken(
    String token,
  ) async {

    await storage.write(
      key: _tokenKey,
      value: token,
    );
  }

  @override
  Future<String?> getToken() async {

    return await storage.read(
      key: _tokenKey,
    );
  }

  @override
  Future<void> clearToken() async {

    await storage.delete(
      key: _tokenKey,
    );
  }
}