import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';

class TextFieldWidgetEntity extends BaseWidgetEntity {
  final String inputType; // text, number, email...
  final int? maxLength;
  final int? minLength;

  const TextFieldWidgetEntity({
    required super.id,
    required super.label,
    required super.isRequired,
    super.regex,
    required this.inputType,
    this.maxLength,
    this.minLength,
  });

  @override
  String? validate(dynamic value) {
    final text = value as String? ?? '';

    // 1. فحص الإلزامية
    if (isRequired && text.trim().isEmpty) {
      return 'حقل $label مطلوب';
    }

    // إذا فارغ وغير إلزامي — لا داعي لفحص باقي القواعد
    if (text.trim().isEmpty) return null;

    // 2. فحص الحد الأدنى للطول
    if (minLength != null && text.length < minLength!) {
      return '$label يجب أن لا يقل عن $minLength أحرف';
    }

    // 3. فحص الحد الأقصى للطول
    if (maxLength != null && text.length > maxLength!) {
      return '$label يجب أن لا يتجاوز $maxLength أحرف';
    }

    // 4. فحص الـ regex إن أرسله الباك
    if (regex != null) {
      final regExp = RegExp(regex!);
      if (!regExp.hasMatch(text)) {
        return 'صيغة $label غير صحيحة';
      }
    }

    return null; // كل شيء تمام
  }

  @override
Map<String, dynamic> toRawData() {
  return {
    'id': id,
    'label': label,
    'is_required': isRequired,
    if (regex != null) 'regex': regex,
    'input_type': inputType,
    if (maxLength != null) 'max_length': maxLength,
    if (minLength != null) 'min_length': minLength,
  };
}
}