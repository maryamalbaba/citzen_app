
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/file_picker_widget_entity.dart';

class FilePickerWidgetModel {
  final String id;
  final String label;
  final bool isRequired;
  final String? regex;
  final double maxSizeMb;
  final List<String> allowedExtensions;
  final bool allowMultiple;
  final int typeDocId;

  const FilePickerWidgetModel({
    required this.id,
    required this.label,
    required this.isRequired,
    this.regex,
    required this.maxSizeMb,
    required this.allowedExtensions,
    required this.allowMultiple,
    required this.typeDocId,
  });

  factory FilePickerWidgetModel.fromJson(Map<String, dynamic> json) {
    return FilePickerWidgetModel(
      id: json['id'] as String,
      label: json['label'] as String,
      isRequired: json['is_required'] as bool,
      regex: json['regex'] as String?,
      // الباك ممكن يرسلها int أو double
      maxSizeMb: (json['max_size_mb'] as num).toDouble(),
      allowedExtensions: List<String>.from(json['allowed_extensions'] as List),
      allowMultiple: json['allow_multiple'] as bool,
      typeDocId: json['type_doc_id'] as int,
    );
  }

  FilePickerWidgetEntity toEntity() {
    return FilePickerWidgetEntity(
      id: id,
      label: label,
      isRequired: isRequired,
      regex: regex,
      maxSizeMb: maxSizeMb,
      allowedExtensions: allowedExtensions,
      allowMultiple: allowMultiple,
      typeDocId: typeDocId,
    );
  }
}