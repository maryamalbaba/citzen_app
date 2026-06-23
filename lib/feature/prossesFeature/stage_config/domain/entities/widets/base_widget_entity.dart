abstract class BaseWidgetEntity {
  final String id;
  final String label;
  final bool isRequired;
  final String? regex; // اختياري — يرسله الباك أو لا

  const BaseWidgetEntity({
    required this.id,
    required this.label,
    required this.isRequired,
    this.regex,
  });

  /// كل widget يطبق منطق الـ validation الخاص فيه
  String? validate(dynamic value);
}