import 'package:citzenapp/core/resource/color_manager.dart';
import 'package:citzenapp/core/theme/app_input_decoration.dart';

import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/text_field_widget_entity.dart';
import 'package:flutter/material.dart';

class TextFieldFormWidget extends StatelessWidget {
  final TextFieldWidgetEntity entity;
  final Map<String, dynamic> formValues;

  const TextFieldFormWidget({
    super.key,
    required this.entity,
    required this.formValues,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              entity.label,
              style: const TextStyle(
                fontSize: 13,
                color: ColorManager.darkGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (entity.isRequired)
              const Text(
                ' *',
                style: TextStyle(color: ColorManager.red, fontSize: 14),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          maxLength: entity.maxLength,
          keyboardType: entity.inputType == 'number'
              ? TextInputType.number
              : TextInputType.text,
          style: const TextStyle(fontSize: 14, color: Color(0xff1a1a1a)),
          decoration: appInputDecoration(hint: entity.label).copyWith(
            counterText: '',
          ),
          onChanged: (val) => formValues[entity.id] = val,
          validator: (val) => entity.validate(val),
        ),
      ],
    );
  }
}