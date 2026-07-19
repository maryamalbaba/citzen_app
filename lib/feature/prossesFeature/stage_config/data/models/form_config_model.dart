import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/templlate_mpdel.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/widgets/widget_parser.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/form_config_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';

class FormConfigModel {
  final String formId;
  final String formName;
  final List<dynamic> widgetsJson;
  final List<int> templateIds; // ← فقط ids
  // final int transactionId;

  const FormConfigModel({
    required this.formId,
    required this.formName,
    required this.widgetsJson,
    required this.templateIds,
    // required this.transactionId,
  });

  factory FormConfigModel.fromJson(Map<String, dynamic> json) {
    final configJson = json['data']['config_json'] as Map<String, dynamic>;

    // نقرأ template_id من كل عنصر في القائمة
    final rawTemplates =
        (configJson['templates'] ?? configJson['template']) as List? ?? [];

    final ids = rawTemplates
        .map((t) {
          final map = t as Map<String, dynamic>;
          // يقبل template_id أو id
          return (map['template_id'] ?? map['id']) as int?;
        })
        .whereType<int>()
        .toList();

    return FormConfigModel(
      formId: configJson['form_id'] as String,
      formName: configJson['form_name'] as String,
      widgetsJson: configJson['widgets'] as List? ?? [],
      templateIds: ids,
      // transactionId: json['data']['transaction_id'] as int,
    );
  }

  FormConfigEntity toEntity() {
    final parsedWidgets = widgetsJson
        .map((w) => WidgetParser.parse(w as Map<String, dynamic>))
        .whereType<BaseWidgetEntity>()
        .toList();

    return FormConfigEntity(
      formId: formId,
      formName: formName,
      widgets: parsedWidgets,
      templates: const [], // فارغة حتى نجلبها
      templateIds: templateIds,
      // transactionId: transactionId,
    );
  }
}