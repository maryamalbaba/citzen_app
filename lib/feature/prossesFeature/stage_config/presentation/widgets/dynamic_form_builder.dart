import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/check_list_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/date_picker_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/dropdown_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/file_picker_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/radio_group_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/text_field_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/widgets/check_list_form_widget.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/widgets/date_picker_form_widget.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/widgets/dropdown_form_widget.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/widgets/file_picker_form_widget.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/widgets/radio_group_form_widget.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/widgets/text_field_form_widget.dart';
import 'package:flutter/material.dart';

class DynamicFormBuilder extends StatelessWidget {
  final List<BaseWidgetEntity> widgets;
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> formValues;

  const DynamicFormBuilder({
    super.key,
    required this.widgets,
    required this.formKey,
    required this.formValues,
  });

  // القلب — يقرر أي widget يبني بناءً على نوع الـ entity
  Widget _buildWidget(BaseWidgetEntity entity) {
    return switch (entity) {
      TextFieldWidgetEntity e => TextFieldFormWidget(
          entity: e,
          formValues: formValues,
        ),
      DropdownWidgetEntity e => DropdownFormWidget(
          entity: e,
          formValues: formValues,
        ),
      RadioGroupWidgetEntity e => RadioGroupFormWidget(
          entity: e,
          formValues: formValues,
        ),
      CheckListWidgetEntity e => CheckListFormWidget(
          entity: e,
          formValues: formValues,
        ),
      DatePickerWidgetEntity e => DatePickerFormWidget(
          entity: e,
          formValues: formValues,
        ),
      FilePickerWidgetEntity e => FilePickerFormWidget(
          entity: e,
          formValues: formValues,
        ),
      _ => const SizedBox.shrink(), // أي نوع غير معروف نتجاهله بأمان
    };
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widgets
            .map(
              (entity) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildWidget(entity),
              ),
            )
            .toList(),
      ),
    );
  }
}