import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/widgets/widget_parser.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/template_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';

class TemplateModel {
  final int id;
  final List<dynamic> widgetsJson;

  const TemplateModel({
    required this.id,
    required this.widgetsJson,
  });

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id'] as int,
      widgetsJson: json['widgets'] as List? ?? [],
    );
  }

  TemplateEntity toEntity() {
    final parsedWidgets = widgetsJson
        .map((w) => WidgetParser.parse(w as Map<String, dynamic>))
        .whereType<BaseWidgetEntity>()
        .toList();

    return TemplateEntity(
      id: id,
      widgets: parsedWidgets,
    );
  }
}