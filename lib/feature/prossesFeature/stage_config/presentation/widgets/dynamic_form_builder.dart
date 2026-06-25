import 'package:citzenapp/core/resource/color_manager.dart';

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
  final Map<String, dynamic> formValues;

  const DynamicFormBuilder({
    super.key,
    required this.widgets,
    required this.formValues,
  });

  Widget _wrapInCard(Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorManager.brown.withOpacity(0.2)),
      ),
      child: child,
    );
  }

  Widget _buildWidget(BaseWidgetEntity entity) {
    return switch (entity) {
      TextFieldWidgetEntity e => _wrapInCard(
          TextFieldFormWidget(entity: e, formValues: formValues)),
      DropdownWidgetEntity e => _wrapInCard(
          DropdownFormWidget(entity: e, formValues: formValues)),
      RadioGroupWidgetEntity e => _wrapInCard(
          RadioGroupFormWidget(entity: e, formValues: formValues)),
      CheckListWidgetEntity e => _wrapInCard(
          CheckListFormWidget(entity: e, formValues: formValues)),
      DatePickerWidgetEntity e => _wrapInCard(
          DatePickerFormWidget(entity: e, formValues: formValues)),
      FilePickerWidgetEntity e => _wrapInCard(
          FilePickerFormWidget(entity: e)),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets.map((entity) => _buildWidget(entity)).toList(),
    );
  }
}