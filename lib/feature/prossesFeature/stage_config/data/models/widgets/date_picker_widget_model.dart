
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/date_picker_widget_entity.dart';

class DatePickerWidgetModel {
  final String id;
  final String label;
  final bool isRequired;
  final String? regex;
  final DateTime? minDate;
  final DateTime? maxDate;

  const DatePickerWidgetModel({
    required this.id,
    required this.label,
    required this.isRequired,
    this.regex,
    this.minDate,
    this.maxDate,
  });

  factory DatePickerWidgetModel.fromJson(Map<String, dynamic> json) {
    return DatePickerWidgetModel(
      id: json['id'] as String,
      label: json['label'] as String,
      isRequired: json['is_required'] as bool,
      regex: json['regex'] as String?,
      // نحول الـ String للـ DateTime هنا مباشرة
      minDate: json['min_date'] != null
          ? DateTime.tryParse(json['min_date'] as String)
          : null,
      maxDate: json['max_date'] != null
          ? DateTime.tryParse(json['max_date'] as String)
          : null,
    );
  }

  DatePickerWidgetEntity toEntity() {
    return DatePickerWidgetEntity(
      id: id,
      label: label,
      isRequired: isRequired,
      regex: regex,
      minDate: minDate,
      maxDate: maxDate,
    );
  }
}