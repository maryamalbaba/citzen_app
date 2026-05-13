//لاحقًا سنعمل implementation بـ:
// FlutterSecureStorage
abstract class TokenStorage {

  Future<void> saveToken(
    String token,
  );

  Future<String?> getToken();

  Future<void> clearToken();
}