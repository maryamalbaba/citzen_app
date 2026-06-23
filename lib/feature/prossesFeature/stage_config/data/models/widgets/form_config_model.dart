
import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/widgets/widget_parser.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/form_config_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';

class FormConfigModel {
  final String formId;
  final String formName;
  final List<dynamic> widgetsJson;
 // final int transactionId;

  const FormConfigModel({
    required this.formId,
    required this.formName,
    required this.widgetsJson,
    // required this.transactionId,
  });

  factory FormConfigModel.fromJson(Map<String, dynamic> json) {
    final configJson = json['data']['config_json'] as Map<String, dynamic>;

    return FormConfigModel(
      formId: configJson['form_id'] as String,
      formName: configJson['form_name'] as String,
      widgetsJson: configJson['widgets'] as List,
      // transactionId: json['data']['transaction_id'] as int,
    );
  }

  FormConfigEntity toEntity() {
    // هنا يمر كل widget على الـ Parser
    final parsedWidgets = widgetsJson
        .map((w) => WidgetParser.parse(w as Map<String, dynamic>))
        .whereType<BaseWidgetEntity>() // يتجاهل الـ null (widget_type غير معروف)
        .toList();

    return FormConfigEntity(
      formId: formId,
      formName: formName,
      widgets: parsedWidgets,
     // transactionId: transactionId,
    );
  }
}