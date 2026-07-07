class SubmitWidgetEntity {
  final String widgetType;
  final Map<String, dynamic> data; // نفس الـ data الذي استلمناه
  final dynamic value;             // ما عبأه المستخدم

  const SubmitWidgetEntity({
    required this.widgetType,
    required this.data,
    required this.value,
  });
}

class SubmitTemplateEntity {
  final int id;
  final List<SubmitWidgetEntity> widgets;

  const SubmitTemplateEntity({
    required this.id,
    required this.widgets,
  });
}
class SubmitFormEntity {
  final String firstName;
  final String lastName;
  final String fatherName;
  final String motherName;
  final String nationalId; 
  final String formId;
  final String formName;
  final List<SubmitWidgetEntity> widgets;
  final List<SubmitTemplateEntity> templates; 
  final String note;

  const SubmitFormEntity({
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.motherName,
    required this.nationalId,
    required this.formId,
    required this.formName,
    required this.widgets,
    this.templates = const [],
    this.note = '',
  });
}