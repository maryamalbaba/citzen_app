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
    return DropdownButtonFormField<String>(
      value: _selectedKey,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xff25624F)),
      dropdownColor: const Color(0xffF9F6EB),
      menuMaxHeight: 300, // استجابة ذكية للشاشات الصغيرة لمنع التمدد الكامل
      style: const TextStyle(color: Color(0xff25624F), fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: widget.entity.label,
        labelStyle: const TextStyle(color: Color(0xff817D7D), fontSize: 14),
        floatingLabelStyle: const TextStyle(color: Color(0xff25624F), fontWeight: FontWeight.bold),
        filled: true,
        fillColor: const Color(0xffF9F6EB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffB8A47C), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff25624F), width: 2),
        ),
      ),
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
    );
  }
}