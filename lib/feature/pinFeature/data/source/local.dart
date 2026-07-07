import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// السيرفر لا يوفّر Endpoint لمعرفة "هل يملك المستخدم PIN أم لا"،
/// لذلك نحتفظ بعلامة محلية بسيطة: تُفعَّل بعد نجاح setup-pin،
/// وتُستخدم لتقرير عرض شاشة "تحقق" أو تجاوزها عند فتح التطبيق.
// abstract class PinLocalDataSource {
//   Future<void> setPinCreated(bool value);
//   Future<bool> isPinCreated();
//   Future<void> clearPinFlag();
// }

// class PinLocalDataSourceImpl implements PinLocalDataSource {
//   final FlutterSecureStorage storage;

//   PinLocalDataSourceImpl(this.storage);

//   static const String _pinCreatedKey = 'pin_created_flag';

//   @override
//   Future<void> setPinCreated(bool value) async {
//     await storage.write(key: _pinCreatedKey, value: value.toString());
//   }

//   @override
//   Future<bool> isPinCreated() async {
//     final value = await storage.read(key: _pinCreatedKey);
//     return value == 'true';
//   }

//   @override
//   Future<void> clearPinFlag() async {
//     await storage.delete(key: _pinCreatedKey);
//   }
// }

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class PinLocalDataSource {
  Future<void> setPinCreated(bool value);
  Future<bool> isPinCreated();
  Future<void> clearPinFlag();
}

class PinLocalDataSourceImpl implements PinLocalDataSource {
  final FlutterSecureStorage storage;

  PinLocalDataSourceImpl(this.storage);

  static const String _pinCreatedKeyPrefix = 'pin_created_flag_';
  // 🆕 نفس مفتاح التوكن المستخدم في SecureTokenStorage، لقراءته وفك تشفيره
  static const String _accessTokenKey = 'token';

  /// يستخرج معرّف المستخدم (id) من التوكن الحالي عبر فك تشفير الـ JWT يدوياً
  /// (بدون أي حزمة خارجية)، ليُستخدم كجزء من مفتاح تخزين علم الـ PIN.
  /// هذا يضمن أن كل حساب على نفس الجهاز له حالة PIN مستقلة تماماً.
  Future<String?> _currentUserId() async {
    try {
      final token = await storage.read(key: _accessTokenKey);
      if (token == null) return null;

      final parts = token.split('.');
      if (parts.length != 3) return null;

      String payload = parts[1];
      // Base64Url يحتاج padding أحياناً
      payload = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(payload));
      final Map<String, dynamic> json = jsonDecode(decoded);

      return json['id']?.toString();
    } catch (_) {
      return null; // أي فشل في فك التشفير = لا نستطيع تحديد المستخدم بأمان
    }
  }

  Future<String> _keyFor(String userId) => Future.value('$_pinCreatedKeyPrefix$userId');

  @override
  Future<void> setPinCreated(bool value) async {
    final userId = await _currentUserId();
    if (userId == null) return; // لا يوجد توكن صالح، لا شيء لتخزينه
    final key = await _keyFor(userId);
    await storage.write(key: key, value: value.toString());
  }

  @override
  Future<bool> isPinCreated() async {
    final userId = await _currentUserId();
    if (userId == null) return false; // لا مستخدم مسجَّل = بالتأكيد لا PIN
    final key = await _keyFor(userId);
    final value = await storage.read(key: key);
    return value == 'true';
  }

  @override
  Future<void> clearPinFlag() async {
    final userId = await _currentUserId();
    if (userId == null) return;
    final key = await _keyFor(userId);
    await storage.delete(key: key);
  }
}