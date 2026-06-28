import 'package:citzenapp/core/resource/color_manager.dart';

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
  final firstDate = widget.entity.minDate ?? DateTime(1900);
  final lastDate = widget.entity.maxDate ?? DateTime(2100);

  // initialDate يجب أن تكون بين firstDate و lastDate دائماً
  DateTime initialDate;
  if (_selectedDate != null) {
    initialDate = _selectedDate!;
  } else if (now.isAfter(lastDate)) {
    // اليوم بعد الحد الأقصى — نبدأ من الحد الأقصى
    initialDate = lastDate;
  } else if (now.isBefore(firstDate)) {
    // اليوم قبل الحد الأدنى — نبدأ من الحد الأدنى
    initialDate = firstDate;
  } else {
    initialDate = now;
  }

  final picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: ColorManager.primaryGreen,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xff1a1a1a),
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
            GestureDetector(
              onTap: () => _pickDate(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 13),
                decoration: BoxDecoration(
                  color: ColorManager.extraLightBaieg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: field.errorText != null
                        ? ColorManager.red
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: _selectedDate != null
                          ? ColorManager.primaryGreen
                          : ColorManager.gray,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _selectedDate != null
                          ? _formatDate(_selectedDate!)
                          : 'اختر التاريخ',
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedDate != null
                            ? const Color(0xff1a1a1a)
                            : ColorManager.gray,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, right: 4),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(
                      color: ColorManager.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}