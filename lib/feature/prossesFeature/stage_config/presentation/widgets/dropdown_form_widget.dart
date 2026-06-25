import 'package:citzenapp/core/resource/color_manager.dart';
import 'package:citzenapp/core/theme/app_input_decoration.dart';

import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/dropdown_widget_entity.dart';
import 'package:flutter/material.dart';

class DropdownFormWidget extends StatefulWidget {
  final DropdownWidgetEntity entity;
  final Map<String, dynamic> formValues;

  const DropdownFormWidget({
    super.key,
    required this.entity,
    required this.formValues,
  });

  @override
  State<DropdownFormWidget> createState() => _DropdownFormWidgetState();
}

class _DropdownFormWidgetState extends State<DropdownFormWidget> {
  String? _selectedKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.entity.label,
              style: const TextStyle(
                fontSize: 13,
                color: ColorManager.darkGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (widget.entity.isRequired)
              const Text(
                ' *',
                style: TextStyle(color: ColorManager.red, fontSize: 14),
              ),
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedKey,
          decoration: appInputDecoration(hint: 'اختر ${widget.entity.label}'),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: ColorManager.gray),
          style: const TextStyle(fontSize: 14, color: Color(0xff1a1a1a)),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          items: widget.entity.options
              .map(
                (option) => DropdownMenuItem(
                  value: option.key,
                  child: Text(option.value),
                ),
              )
              .toList(),
          onChanged: (val) {
            setState(() => _selectedKey = val);
            widget.formValues[widget.entity.id] = val;
          },
          validator: (_) => widget.entity.validate(_selectedKey),
        ),
      ],
    );
  }
}