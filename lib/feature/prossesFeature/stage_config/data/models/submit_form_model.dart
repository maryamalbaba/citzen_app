import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/submit_form_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/uploaded_file_entity.dart';

class SubmitFormModel {
  static Map<String, dynamic> toJson(SubmitFormEntity entity) {
    return {
      'first_name': entity.firstName,
      'last_name': entity.lastName,
      'father_name': entity.fatherName,
      'mother_name': entity.motherName,
      'national_id': entity.nationalId, 
      'form_id': entity.formId,
      'form_name': entity.formName,
      'widgets': entity.widgets
          .map((w) => _widgetToJson(w))
          .toList(),
      'templates': entity.templates,
      'note': entity.note,
    };
  }

  static Map<String, dynamic> _widgetToJson(SubmitWidgetEntity widget) {
    return {
      'widget_type': widget.widgetType,
      'data': widget.data,
      'value': _formatValue(widget.widgetType, widget.value),
    };
  }

  // كل نوع widget له طريقة تحويل القيمة المناسبة
  static dynamic _formatValue(String widgetType, dynamic value) {
    switch (widgetType) {

      case 'text_field':
        // String مباشرة
        return value as String? ?? '';

      case 'dropdown':
      case 'radio_group':
        // نرسل الـ key المختار
        return value as String? ?? '';

      case 'check_list':
        // مصفوفة من الـ keys المختارة
        return value as List<String>? ?? [];

      case 'date_picker':
        // DateTime نحولها لـ String بصيغة yyyy-MM-dd
        if (value is DateTime) {
          return '${value.year}-'
              '${value.month.toString().padLeft(2, '0')}-'
              '${value.day.toString().padLeft(2, '0')}';
        }
        return '';

      case 'file_picker':
  // نرسل object كامل بدل url فقط
  if (value is List) {
    return value.map((e) {
      if (e is UploadedFileEntity) {
        return {
          'url': e.url,
          'path': e.path,
          'type_doc_id': e.typeDocId,
          'original_name': e.originalName,
          'mime_type': e.mimeType,
          'key': e.key,
        };
      }
      return e;
    }).toList();
  }
  return [];
  }
}}