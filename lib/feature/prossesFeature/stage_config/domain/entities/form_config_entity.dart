import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/template_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';

class FormConfigEntity {
  final String formId;
  final String formName;
  final List<BaseWidgetEntity> widgets;
  final List<TemplateEntity> templates;
  final List<int> templateIds; // ← جديد — الـ ids القادمة من الـ config
  // final int transactionId;

  const FormConfigEntity({
    required this.formId,
    required this.formName,
    required this.widgets,
    required this.templates,
    required this.templateIds,
    // required this.transactionId,
  });

  // نسخة محدثة مع الـ templates بعد جلبها
  FormConfigEntity copyWith({List<TemplateEntity>? templates}) {
    return FormConfigEntity(
      formId: formId,
      formName: formName,
      widgets: widgets,
      templates: templates ?? this.templates,
      templateIds: templateIds,
      // transactionId: transactionId,
    );
  }
}