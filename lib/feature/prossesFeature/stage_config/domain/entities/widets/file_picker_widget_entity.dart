import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';

class FilePickerWidgetEntity extends BaseWidgetEntity {
  final double maxSizeMb;
  final List<String> allowedExtensions;
  final bool allowMultiple;
  final int typeDocId;

  const FilePickerWidgetEntity({
    required super.id,
    required super.label,
    required super.isRequired,
    super.regex,
    required this.maxSizeMb,
    required this.allowedExtensions,
    required this.allowMultiple,
    required this.typeDocId,
  });

  @override
  String? validate(dynamic value) {
    // القيمة هنا ستكون List<PlatformFile> من مكتبة file_picker
    final files = value as List? ?? [];

    // 1. فحص الإلزامية
    if (isRequired && files.isEmpty) {
      return 'يرجى إرفاق $label';
    }

    if (files.isEmpty) return null;

    // 2. فحص الامتداد والحجم — هذا سيتم داخل الـ UI Widget مباشرة
    // لأن الـ PlatformFile يحتوي على extension و size
    // لذلك نترك هذا المنطق في طبقة الـ Presentation
    // وهنا في الـ entity نفحص فقط إن وجد ملف أم لا

    return null;
  }
  @override
Map<String, dynamic> toRawData() {
  return {
    'id': id,
    'label': label,
    'is_required': isRequired,
    if (regex != null) 'regex': regex,
    'max_size_mb': maxSizeMb,
    'allowed_extensions': allowedExtensions,
    'allow_multiple': allowMultiple,
    'type_doc_id': typeDocId,
  };
}
}