import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';

class DatePickerWidgetEntity extends BaseWidgetEntity {
  final DateTime? minDate;
  final DateTime? maxDate;

  const DatePickerWidgetEntity({
    required super.id,
    required super.label,
    required super.isRequired,
    super.regex,
    this.minDate,
    this.maxDate,
  });

  @override
  String? validate(dynamic value) {
    final date = value as DateTime?;

    // 1. فحص الإلزامية
    if (isRequired && date == null) {
      return 'يرجى تحديد $label';
    }

    if (date == null) return null;

    // 2. فحص الحد الأدنى للتاريخ
    if (minDate != null && date.isBefore(minDate!)) {
      return '$label يجب أن لا يكون قبل ${_formatDate(minDate!)}';
    }

    // 3. فحص الحد الأقصى للتاريخ
    if (maxDate != null && date.isAfter(maxDate!)) {
      return '$label يجب أن لا يكون بعد ${_formatDate(maxDate!)}';
    }

    // 4. regex على التاريخ كـ String إن وُجد
    if (regex != null) {
      final dateString = date.toIso8601String().split('T').first;
      final regExp = RegExp(regex!);
      if (!regExp.hasMatch(dateString)) {
        return 'صيغة $label غير صحيحة';
      }
    }

    return null;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  @override
Map<String, dynamic> toRawData() {
  return {
    'id': id,
    'label': label,
    'is_required': isRequired,
    if (regex != null) 'regex': regex,
    if (minDate != null)
      'min_date': '${minDate!.year}-${minDate!.month.toString().padLeft(2, '0')}-${minDate!.day.toString().padLeft(2, '0')}',
    if (maxDate != null)
      'max_date': '${maxDate!.year}-${maxDate!.month.toString().padLeft(2, '0')}-${maxDate!.day.toString().padLeft(2, '0')}',
  };
}
}