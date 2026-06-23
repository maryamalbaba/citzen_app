import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/dropdown_widget_entity.dart';

class RadioGroupWidgetEntity extends BaseWidgetEntity {
  final List<DropdownOptionEntity> options;
  // نعيد استخدام DropdownOptionEntity لأن البنية مطابقة تماماً {key, value}

  const RadioGroupWidgetEntity({
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

    // 2. التأكد أن الـ key المختار موجود فعلاً في الـ options
    final isValid = options.any((option) => option.key == selected);
    if (!isValid) {
      return 'الاختيار في $label غير صالح';
    }

    // 3. regex إن وُجد
    if (regex != null) {
      final regExp = RegExp(regex!);
      if (!regExp.hasMatch(selected)) {
        return 'صيغة $label غير صحيحة';
      }
    }

    return null;
  }
}