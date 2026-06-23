
import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/widgets/check_list_widget_model.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/widgets/date_picker_widget_model.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/widgets/dropdown_widget_model.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/widgets/file_picker_widget_model.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/widgets/radio_group_widget_model.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/widgets/text_field_widget_model.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';

class WidgetParser {
  WidgetParser._(); // منع الإنشاء — static فقط

  static BaseWidgetEntity? parse(Map<String, dynamic> widgetJson) {
    final widgetType = widgetJson['widget_type'] as String?;
    final data = widgetJson['data'] as Map<String, dynamic>?;

    if (widgetType == null || data == null) return null;

    switch (widgetType) {
      case 'text_field':
        return TextFieldWidgetModel.fromJson(data).toEntity();

      case 'dropdown':
        return DropdownWidgetModel.fromJson(data).toEntity();

      case 'radio_group':
        return RadioGroupWidgetModel.fromJson(data).toEntity();

      case 'check_list':
        return CheckListWidgetModel.fromJson(data).toEntity();

      case 'date_picker':
        return DatePickerWidgetModel.fromJson(data).toEntity();

      case 'file_picker':
        return FilePickerWidgetModel.fromJson(data).toEntity();

      default:
        // widget_type غير معروف — نتجاهله بأمان
        return null;
    }
  }
}