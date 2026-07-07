
import 'package:citzenapp/feature/pinFeature/domin/entity/messageentity.dart';

/// يطابق شكل الاستجابة:
/// { "success": true, "status_code": 200, "message": "...", "data": { "message": "..." } }
class PinMessageModel extends PinMessage {
  const PinMessageModel({required super.message});

  factory PinMessageModel.fromJson(Map<String, dynamic> json) {
    // بعض الاستجابات تضع الرسالة داخل data.message وأخرى في message مباشرة،
    // لذلك نتعامل مع الحالتين بأمان.
    final data = json['data'];
    final nestedMessage =
        (data is Map<String, dynamic>) ? data['message'] as String? : null;

    return PinMessageModel(
      message: nestedMessage ?? json['message'] as String? ?? '',
    );
  }
}