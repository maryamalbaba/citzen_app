import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/text_field_widget_entity.dart';

class TextFieldWidgetModel {
  final String id;
  final String label;
  final bool isRequired;
  final String? regex;
  final String inputType;
  final int? maxLength;
  final int? minLength;

  const TextFieldWidgetModel({
    required this.id,
    required this.label,
    required this.isRequired,
    this.regex,
    required this.inputType,
    this.maxLength,
    this.minLength,
  });

  factory TextFieldWidgetModel.fromJson(Map<String, dynamic> json) {
    return TextFieldWidgetModel(
      id: json['id'] as String,
      label: json['label'] as String,
      isRequired: json['is_required'] as bool,
      regex: json['regex'] as String?,
      inputType: json['input_type'] as String? ?? 'text',
      maxLength: json['max_length'] as int?,
      minLength: json['min_length'] as int?,
    );
  }

  TextFieldWidgetEntity toEntity() {
    return TextFieldWidgetEntity(
      id: id,
      label: label,
      isRequired: isRequired,
      regex: regex,
      inputType: inputType,
      maxLength: maxLength,
      minLength: minLength,
    );
  }
}