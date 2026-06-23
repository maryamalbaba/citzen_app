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
    return TextFormField(
      maxLength: entity.maxLength,
      keyboardType: entity.inputType == 'number'
          ? TextInputType.number
          : TextInputType.text,
      style: const TextStyle(color: Color(0xff25624F), fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: entity.label,
        labelStyle: const TextStyle(color: Color(0xff817D7D), fontSize: 14),
        floatingLabelStyle: const TextStyle(color: Color(0xff25624F), fontWeight: FontWeight.bold),
        hintText: entity.label,
        hintStyle: const TextStyle(color: Color(0xff817D7D), fontSize: 13),
        counterText: '',
        filled: true,
        fillColor: const Color(0xffF9F6EB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffB8A47C), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff25624F), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
        ),
      ),
      onChanged: (val) => formValues[entity.id] = val,
      validator: (val) => entity.validate(val),
    );
  }
}