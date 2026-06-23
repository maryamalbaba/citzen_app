import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/widgets/dropdown_option_model.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/radio_group_widget_entity.dart';

class RadioGroupWidgetModel {
  final String id;
  final String label;
  final bool isRequired;
  final String? regex;
  final List<DropdownOptionModel> options;

  const RadioGroupWidgetModel({
    required this.id,
    required this.label,
    required this.isRequired,
    this.regex,
    required this.options,
  });

  factory RadioGroupWidgetModel.fromJson(Map<String, dynamic> json) {
    return RadioGroupWidgetModel(
      id: json['id'] as String,
      label: json['label'] as String,
      isRequired: json['is_required'] as bool,
      regex: json['regex'] as String?,
      options: (json['options'] as List)
          .map((o) => DropdownOptionModel.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }

  RadioGroupWidgetEntity toEntity() {
    return RadioGroupWidgetEntity(
      id: id,
      label: label,
      isRequired: isRequired,
      regex: regex,
      options: options.map((o) => o.toEntity()).toList(),
    );
  }
}