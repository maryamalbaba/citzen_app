import 'package:citzenapp/core/resource/color_manager.dart';
import 'package:citzenapp/core/service/utils/regex/regex_message_parser.dart';
import 'package:citzenapp/core/theme/app_input_decoration.dart';

import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/text_field_widget_entity.dart';
import 'package:flutter/material.dart';

class TextFieldFormWidget extends StatefulWidget {
  final TextFieldWidgetEntity entity;
  final Map<String, dynamic> formValues;

  const TextFieldFormWidget({
    super.key,
    required this.entity,
    required this.formValues,
  });

  @override
  State<TextFieldFormWidget> createState() => _TextFieldFormWidgetState();
}

class _TextFieldFormWidgetState extends State<TextFieldFormWidget> {
  // رسالة الـ regex الحالية — null تعني لا يوجد خطأ
  String? _regexHint;
  // هل الحقل تم لمسه من المستخدم
  bool _touched = false;

  void _onChanged(String val) {
    widget.formValues[widget.entity.id] = val;

    if (!_touched) setState(() => _touched = true);

    // لا نشيك إلا إذا في regex وفي قيمة
    if (widget.entity.regex == null || val.isEmpty) {
      if (_regexHint != null) setState(() => _regexHint = null);
      return;
    }

    final regExp = RegExp(widget.entity.regex!);

    if (!regExp.hasMatch(val)) {
      final message = RegexMessageParser.parse(
        widget.entity.regex!,
        widget.entity.label,
      );
      if (_regexHint != message) {
        setState(() => _regexHint = message);
      }
    } else {
      if (_regexHint != null) {
        setState(() => _regexHint = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
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

        // الحقل نفسه
        TextFormField(
          maxLength: widget.entity.maxLength,
          keyboardType: widget.entity.inputType == 'number'
              ? TextInputType.number
              : TextInputType.text,
          style: const TextStyle(fontSize: 14, color: Color(0xff1a1a1a)),
          decoration: appInputDecoration(hint: widget.entity.label).copyWith(
            counterText: '',
            // نغير لون البوردر إذا في خطأ regex
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: _regexHint != null && _touched
                  ? const BorderSide(color: ColorManager.brown, width: 1.5)
                  : BorderSide.none,
            ),
          ),
          onChanged: _onChanged,
          validator: (val) => widget.entity.validate(val),
        ),

        // hint الـ regex — يظهر ويختفي بـ animation
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _regexHint != null && _touched
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: ColorManager.brown.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorManager.brown.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: ColorManager.brown,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _regexHint!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: ColorManager.brown,
                            height: 1.6,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}