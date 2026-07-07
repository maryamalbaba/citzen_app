import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/template_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';

class FormConfigEntity {
  final String formId;
  final String formName;
  final List<BaseWidgetEntity> widgets;
  final List<TemplateEntity> templates; // ← عدلنا من List<dynamic>
  // final int transactionId;

  const FormConfigEntity({
    required this.formId,
    required this.formName,
    required this.widgets,
    required this.templates,
    // required this.transactionId,
  });
}
