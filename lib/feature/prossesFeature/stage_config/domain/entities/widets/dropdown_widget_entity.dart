import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';

class DropdownOptionEntity {
  final String key;
  final String value;

  const DropdownOptionEntity({
    required this.key,
    required this.value,
  });
}

class DropdownWidgetEntity extends BaseWidgetEntity {
  final List<DropdownOptionEntity> options;

  const DropdownWidgetEntity({
    required super.id,
    required super.label,
    required super.isRequired,
    super.regex,
    required this.options,
  });

  @override
  String? validate(dynamic value) {
    final selected = value as String? ?? '';

    // 1. فحص الإلزامية
    if (isRequired && selected.isEmpty) {
      return 'يرجى اختيار $label';
    }

    if (selected.isEmpty) return null;

    // 2. التأكد أن القيمة المختارة موجودة فعلاً في الـ options (key)
    final isValid = options.any((option) => option.key == selected);
    if (!isValid) {
      return 'الاختيار في $label غير صالح';
    }

    // 3. فحص الـ regex إن وُجد (نادر في الـ dropdown لكن نحترم ما يرسله الباك)
    if (regex != null) {
      final regExp = RegExp(regex!);
      if (!regExp.hasMatch(selected)) {
        return 'صيغة $label غير صحيحة';
      }
    }

    return null;
  }
}