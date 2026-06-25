import 'package:citzenapp/core/resource/color_manager.dart';

import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/radio_group_widget_entity.dart';
import 'package:flutter/material.dart';

class RadioGroupFormWidget extends StatefulWidget {
  final RadioGroupWidgetEntity entity;
  final Map<String, dynamic> formValues;

  const RadioGroupFormWidget({
    super.key,
    required this.entity,
    required this.formValues,
  });

  @override
  State<RadioGroupFormWidget> createState() => _RadioGroupFormWidgetState();
}

class _RadioGroupFormWidgetState extends State<RadioGroupFormWidget> {
  String? _selectedKey;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (_) {
        final error = widget.entity.validate(_selectedKey);
        setState(() => _errorText = error);
        return error;
      },
      builder: (_) {
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
            Container(
              decoration: BoxDecoration(
                color: ColorManager.extraLightBaieg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: widget.entity.options.map((option) {
                  final isSelected = _selectedKey == option.key;
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedKey = option.key);
                      widget.formValues[widget.entity.id] = option.key;
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? ColorManager.primaryGreen
                                    : ColorManager.brown,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorManager.primaryGreen,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            option.value,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? ColorManager.primaryGreen
                                  : const Color(0xff1a1a1a),
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (_errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, right: 4),
                child: Text(
                  _errorText!,
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