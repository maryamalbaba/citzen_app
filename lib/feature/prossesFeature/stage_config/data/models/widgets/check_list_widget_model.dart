
import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/widgets/dropdown_option_model.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/check_list_widget_entity.dart';

class CheckListWidgetModel {
  final String id;
  final String label;
  final bool isRequired;
  final String? regex;
  final List<DropdownOptionModel> options;
  final int? minSelected;
  final int? maxSelected;

  const CheckListWidgetModel({
    required this.id,
    required this.label,
    required this.isRequired,
    this.regex,
    required this.options,
    this.minSelected,
    this.maxSelected,
  });

  factory CheckListWidgetModel.fromJson(Map<String, dynamic> json) {
    return CheckListWidgetModel(
      id: json['id'] as String,
      label: json['label'] as String,
      isRequired: json['is_required'] as bool,
      regex: json['regex'] as String?,
      options: (json['options'] as List)
          .map((o) => DropdownOptionModel.fromJson(o as Map<String, dynamic>))
          .toList(),
      minSelected: json['min_selected'] as int?,
      maxSelected: json['max_selected'] as int?,
    );
  }

  CheckListWidgetEntity toEntity() {
    return CheckListWidgetEntity(
      id: id,
      label: label,
      isRequired: isRequired,
      regex: regex,
      options: options.map((o) => o.toEntity()).toList(),
      minSelected: minSelected,
      maxSelected: maxSelected,
    );
  }
}