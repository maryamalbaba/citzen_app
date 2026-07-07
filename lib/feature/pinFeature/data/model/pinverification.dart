
import 'package:citzenapp/feature/pinFeature/domin/entity/pin_verevicationEntity.dart';

/// يطابق شكل استجابة /api/auth/verify-app-pin:
/// {
///   "success": true, "status_code": 200, "message": "تم التحقق من رمز PIN بنجاح",
///   "data": { "unlocked": true, "message": "تم فتح التطبيق بنجاح" }
/// }
class PinVerificationResultModel extends PinVerificationResult {
  const PinVerificationResultModel({
    required super.unlocked,
    required super.message,
  });

  factory PinVerificationResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return PinVerificationResultModel(
      unlocked: data['unlocked'] as bool? ?? false,
      message: data['message'] as String? ?? json['message'] as String? ?? '',
    );
  }
}