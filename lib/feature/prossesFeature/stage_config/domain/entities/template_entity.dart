import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';

class TemplateEntity {
  final int id;
  final List<BaseWidgetEntity> widgets;

  const TemplateEntity({
    required this.id,
    required this.widgets,
  });
}