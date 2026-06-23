import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/file_picker_widget_entity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerFormWidget extends StatefulWidget {
  final FilePickerWidgetEntity entity;
  final Map<String, dynamic> formValues;

  const FilePickerFormWidget({
    super.key,
    required this.entity,
    required this.formValues,
  });

  @override
  State<FilePickerFormWidget> createState() => _FilePickerFormWidgetState();
}

class _FilePickerFormWidgetState extends State<FilePickerFormWidget> {
  List<PlatformFile> _pickedFiles = [];
  String? _errorText;

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: widget.entity.allowMultiple,
      type: FileType.custom,
      allowedExtensions: widget.entity.allowedExtensions,
    );

    if (result == null) return;

    final maxBytes = (widget.entity.maxSizeMb * 1024 * 1024).toInt();
    final oversizedFiles = result.files
        .where((f) => (f.size) > maxBytes)
        .map((f) => f.name)
        .toList();

    if (oversizedFiles.isNotEmpty) {
      setState(() {
        _errorText =
            'الملفات التالية تتجاوز ${widget.entity.maxSizeMb} MB: ${oversizedFiles.join(', ')}';
      });
      return;
    }

    setState(() {
      _pickedFiles = result.files;
      _errorText = null;
      widget.formValues[widget.entity.id] = _pickedFiles;
    });
  }

  void _removeFile(int index) {
    setState(() {
      _pickedFiles.removeAt(index);
      widget.formValues[widget.entity.id] = _pickedFiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<PlatformFile>>(
      validator: (_) {
        final error = widget.entity.validate(_pickedFiles);
        setState(() => _errorText = error);
        return error;
      },
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.entity.label,
              style: const TextStyle(color: Color(0xff25624F), fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),

            // منطقة الرفع المصممة بشكل متجاوب وجميل
            InkWell(
              onTap: _pickFiles,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xffF9F6EB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xffB8A47C), width: 1.5, style: BorderStyle.solid),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload_outlined, size: 36, color: Color(0xff25624F)),
                    const SizedBox(height: 8),
                    Text(
                      widget.entity.allowMultiple ? 'اضغط لإرفاق ملفات متعددة' : 'اضغط لإرفاق ملف',
                      style: const TextStyle(color: Color(0xff25624F), fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الصيغ المقبولة: ${widget.entity.allowedExtensions.join(', ')} (بحد أقصى ${widget.entity.maxSizeMb}MB)',
                      style: const TextStyle(fontSize: 11, color: Color(0xff817D7D)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // قائمة الملفات المختارة على هيئة بطاقات مستقلة متجاوبة
            if (_pickedFiles.isNotEmpty) ...[
              const SizedBox(height: 12),
              ..._pickedFiles.asMap().entries.map(
                    (entry) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xffB8A47B).withOpacity(0.3)),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: const Icon(Icons.insert_drive_file_outlined, color: Color(0xffB8A47C)),
                        title: Text(
                          entry.value.name,
                          style: const TextStyle(fontSize: 13, color: Color(0xff25624F), fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${(entry.value.size / 1024).toStringAsFixed(1)} KB',
                          style: const TextStyle(fontSize: 11, color: Color(0xff817D7D)),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                          onPressed: () => _removeFile(entry.key),
                        ),
                      ),
                    ),
                  ),
            ],

            if (_errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
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