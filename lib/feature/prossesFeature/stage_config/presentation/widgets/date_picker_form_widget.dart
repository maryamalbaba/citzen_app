import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/date_picker_widget_entity.dart';
import 'package:flutter/material.dart';

class DatePickerFormWidget extends StatefulWidget {
  final DatePickerWidgetEntity entity;
  final Map<String, dynamic> formValues;

  const DatePickerFormWidget({
    super.key,
    required this.entity,
    required this.formValues,
  });

  @override
  State<DatePickerFormWidget> createState() => _DatePickerFormWidgetState();
}

class _DatePickerFormWidgetState extends State<DatePickerFormWidget> {
  DateTime? _selectedDate;

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ??
          (widget.entity.minDate != null && now.isBefore(widget.entity.minDate!)
              ? widget.entity.minDate!
              : now),
      firstDate: widget.entity.minDate ?? DateTime(1900),
      lastDate: widget.entity.maxDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff25624F), // اللون الأساسي للروزنامة
              onPrimary: Colors.white,
              onSurface: Color(0xff25624F),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
      widget.formValues[widget.entity.id] = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      validator: (_) => widget.entity.validate(_selectedDate),
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _pickDate(context),
              borderRadius: BorderRadius.circular(12), // لمنع خروج تأثير الضغط خارج الحقل
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: widget.entity.label,
                  labelStyle: const TextStyle(color: Color(0xff817D7D), fontSize: 14),
                  floatingLabelStyle: const TextStyle(color: Color(0xff25624F), fontWeight: FontWeight.bold),
                  errorText: field.errorText,
                  filled: true,
                  fillColor: const Color(0xffF9F6EB),
                  suffixIcon: const Icon(Icons.calendar_today_outlined, color: Color(0xff25624F), size: 20),
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
                child: Text(
                  _selectedDate != null ? _formatDate(_selectedDate!) : 'اختر تاريخاً',
                  style: TextStyle(
                    color: _selectedDate == null ? const Color(0xff817D7D) : const Color(0xff25624F),
                    fontSize: 15,
                    fontWeight: _selectedDate == null ? FontWeight.normal : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}