
import 'package:citzenapp/core/resource/color_manager.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/check_list_widget_entity.dart';
import 'package:flutter/material.dart';

class CheckListFormWidget extends StatefulWidget {
  final CheckListWidgetEntity entity;
  final Map<String, dynamic> formValues;

  const CheckListFormWidget({
    super.key,
    required this.entity,
    required this.formValues,
  });

  @override
  State<CheckListFormWidget> createState() => _CheckListFormWidgetState();
}

class _CheckListFormWidgetState extends State<CheckListFormWidget> {
  final List<String> _selectedKeys = [];
  String? _errorText;

  void _onChanged(String key, bool checked) {
    setState(() {
      if (checked) {
        _selectedKeys.add(key);
      } else {
        _selectedKeys.remove(key);
      }
      widget.formValues[widget.entity.id] = List<String>.from(_selectedKeys);
      _errorText = widget.entity.validate(_selectedKeys);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      validator: (_) {
        final error = widget.entity.validate(_selectedKeys);
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
                  final isSelected = _selectedKeys.contains(option.key);
                  return InkWell(
                    onTap: () => _onChanged(option.key, !isSelected),
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
                              borderRadius: BorderRadius.circular(5),
                              color: isSelected
                                  ? ColorManager.primaryGreen
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? ColorManager.primaryGreen
                                    : ColorManager.brown,
                                width: 1.5,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 14)
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