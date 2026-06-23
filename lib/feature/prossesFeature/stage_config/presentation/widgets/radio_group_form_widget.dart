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

  void _validate() {
    setState(() {
      _errorText = widget.entity.validate(_selectedKey);
    });
  }

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
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 4, left: 4),
              child: Text(
                widget.entity.label,
                style: const TextStyle(color: Color(0xff25624F), fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffF9F6EB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _errorText != null ? Theme.of(context).colorScheme.error : const Color(0xffB8A47C),
                  width: 1,
                ),
              ),
              child: Column(
                children: widget.entity.options.map(
                  (option) {
                    final isSelected = _selectedKey == option.key;
                    return RadioListTile<String>(
                      title: Text(
                        option.value,
                        style: TextStyle(
                          color: const Color(0xff25624F),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      value: option.key,
                      groupValue: _selectedKey,
                      activeColor: const Color(0xff25624F),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      onChanged: (val) {
                        setState(() => _selectedKey = val);
                        widget.formValues[widget.entity.id] = val;
                        _validate();
                      },
                    );
                  },
                ).toList(),
              ),
            ),
            if (_errorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 6, right: 12),
                child: Text(
                  _errorText!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}