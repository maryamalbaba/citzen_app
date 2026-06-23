import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/dropdown_widget_entity.dart';

class CheckListWidgetEntity extends BaseWidgetEntity {
  final List<DropdownOptionEntity> options;
  final int? minSelected;
  final int? maxSelected;

  const CheckListWidgetEntity({
    required super.id,
    required super.label,
    required super.isRequired,
    super.regex,
    required this.options,
    this.minSelected,
    this.maxSelected,
  });

  @override
  String? validate(dynamic value) {
    final selectedKeys = value as List<String>? ?? [];

    // 1. فحص الإلزامية
    if (isRequired && selectedKeys.isEmpty) {
      return 'يرجى اختيار خيار واحد على الأقل في $label';
    }

    if (selectedKeys.isEmpty) return null;

    // 2. فحص الحد الأدنى للاختيارات
    if (minSelected != null && selectedKeys.length < minSelected!) {
      return 'يجب اختيار $minSelected عناصر على الأقل في $label';
    }

    // 3. فحص الحد الأقصى للاختيارات
    if (maxSelected != null && selectedKeys.length > maxSelected!) {
      return 'لا يمكن اختيار أكثر من $maxSelected عناصر في $label';
    }

    // 4. التأكد أن كل key مختار موجود فعلاً في الـ options
    final validKeys = options.map((o) => o.key).toSet();
    final hasInvalidKey = selectedKeys.any((key) => !validKeys.contains(key));
    if (hasInvalidKey) {
      return 'أحد الاختيارات في $label غير صالح';
    }

    return null;
  }
}