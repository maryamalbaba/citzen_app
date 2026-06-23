import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';

class FormConfigEntity {
  final String formId;
  final String formName;
  final List<BaseWidgetEntity> widgets;
  // final int transactionId;

  const FormConfigEntity({
    required this.formId,
    required this.formName,
    required this.widgets,
    // required this.transactionId,
  });
}