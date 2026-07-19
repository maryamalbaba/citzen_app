import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/widgets/widget_parser.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/template_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';

class DocumentTemplateModel {
  final int id;
  final String name;
  final List<dynamic> widgetsJson;

  const DocumentTemplateModel({
    required this.id,
    required this.name,
    required this.widgetsJson,
  });

  factory DocumentTemplateModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final configJson = data['config_json'] as Map<String, dynamic>? ?? {};

    return DocumentTemplateModel(
      id: data['id'] as int,
      name: data['name'] as String,
      widgetsJson: configJson['widgets'] as List? ?? [],
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