
import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/widgets/dropdown_option_model.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/dropdown_widget_entity.dart';

class DropdownWidgetModel {
  final String id;
  final String label;
  final bool isRequired;
  final String? regex;
  final List<DropdownOptionModel> options;

  const DropdownWidgetModel({
    required this.id,
    required this.label,
    required this.isRequired,
    this.regex,
    required this.options,
  });

  factory DropdownWidgetModel.fromJson(Map<String, dynamic> json) {
    return DropdownWidgetModel(
      id: json['id'] as String,
      label: json['label'] as String,
      isRequired: json['is_required'] as bool,
      regex: json['regex'] as String?,
      options: (json['options'] as List)
          .map((o) => DropdownOptionModel.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }

  DropdownWidgetEntity toEntity() {
    return DropdownWidgetEntity(
      id: id,
      label: label,
      isRequired: isRequired,
      regex: regex,
      options: options.map((o) => o.toEntity()).toList(),
    );
  }
}