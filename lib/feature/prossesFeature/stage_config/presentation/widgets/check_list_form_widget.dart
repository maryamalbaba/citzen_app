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
                    final isSelected = _selectedKeys.contains(option.key);
                    return CheckboxListTile(
                      title: Text(
                        option.value,
                        style: TextStyle(
                          color: const Color(0xff25624F),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      value: isSelected,
                      activeColor: const Color(0xff25624F),
                      checkColor: Colors.white,
                      checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (checked) => _onChanged(option.key, checked ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
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