import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/dropdown_widget_entity.dart';

class DropdownOptionModel {
  final String key;
  final String value;

  const DropdownOptionModel({
    required this.key,
    required this.value,
  });

  factory DropdownOptionModel.fromJson(Map<String, dynamic> json) {
    return DropdownOptionModel(
      key: json['key'] as String,
      value: json['value'] as String,
    );
  }

  // نحوله لـ entity نظيف
  DropdownOptionEntity toEntity() {
    return DropdownOptionEntity(
      key: key,
      value: value,
    );
  }
}