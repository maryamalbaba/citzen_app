import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/pinFeature/domin/entity/messageentity.dart';
import 'package:citzenapp/feature/pinFeature/domin/entity/pin_verevicationEntity.dart';
import 'package:dartz/dartz.dart';

/// العقد (Contract) الذي تلتزم به طبقة الـ Data.
/// طبقة الـ Domain لا تعرف شيئاً عن Dio أو أي تفاصيل تقنية.
abstract class PinRepository {
  /// POST /api/auth/setup-pin
  Future<Either<Failure, PinMessage>> setupPin({
    required String pin,
    required String confirmPin,
  });

  /// POST /api/auth/verify-app-pin
  Future<Either<Failure, PinVerificationResult>> verifyPin({
    required String pin,
  });

  /// POST /api/auth/change-pin
  Future<Either<Failure, PinMessage>> changePin({
    required String oldPin,
    required String newPin,
    required String confirmNewPin,
  });

  /// فحص محلي (لا يحتاج شبكة): هل قام المستخدم بإنشاء PIN من قبل؟
  /// تُستخدم لتقرير هل نعرض شاشة "إنشاء PIN" أو شاشة "التحقق من PIN" عند فتح التطبيق.
  Future<bool> hasPinCreated();

  /// حذف حالة الـ PIN المحلية (تُستدعى عند تسجيل الخروج مثلاً).
  Future<void> clearLocalPinState();
}
