import 'package:citzenapp/core/resource/color_manager.dart';

import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/file_picker_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/file_bloc.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/file_event.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/file_state.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilePickerFormWidget extends StatelessWidget {
  final FilePickerWidgetEntity entity;

  const FilePickerFormWidget({super.key, required this.entity});

  Future<void> _pickFiles(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: entity.allowMultiple,
      type: FileType.custom,
      allowedExtensions: entity.allowedExtensions,
    );
    if (result == null) return;

    final maxBytes = (entity.maxSizeMb * 1024 * 1024).toInt();
    final validFiles = result.files
        .where((f) => f.size <= maxBytes && f.path != null);

    for (final file in validFiles) {
      // ignore: use_build_context_synchronously
      context.read<FileUploadBloc>().add(
            UploadFileEvent(
              file: file,
              typeDocId: entity.typeDocId,
              key: entity.id,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileUploadBloc, FileUploadState>(
      builder: (context, state) {
        final filesForField = state.filesPerField[entity.id] ?? [];

        return FormField<List<SingleFileState>>(
          validator: (_) {
            final successCount = filesForField
                .where((f) => f.status == FileUploadStatus.success)
                .length;
            if (entity.isRequired && successCount == 0) {
              return 'يرجى إرفاق ${entity.label}';
            }
            return null;
          },
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      entity.label,
                      style: const TextStyle(
                        fontSize: 13,
                        color: ColorManager.darkGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (entity.isRequired)
                      const Text(
                        ' *',
                        style:
                            TextStyle(color: ColorManager.red, fontSize: 14),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _pickFiles(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: ColorManager.extraLightBaieg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: field.errorText != null
                            ? ColorManager.red
                            : ColorManager.brown,
                        width: 1.5,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color:
                                ColorManager.darkGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.cloud_upload_outlined,
                            color: ColorManager.darkGreen,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          entity.allowMultiple
                              ? 'اضغط لإرفاق ملفات متعددة'
                              : 'اضغط لإرفاق ملف',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.darkGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'الصيغ المقبولة: ${entity.allowedExtensions.join(', ')} — بحد أقصى ${entity.maxSizeMb}MB',
                          style: const TextStyle(
                              fontSize: 11, color: ColorManager.gray),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                if (filesForField.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ...filesForField.asMap().entries.map(
                        (entry) => _FileStatusTile(
                          fileState: entry.value,
                          onRemove: () {
                            context.read<FileUploadBloc>().add(
                                  RemoveUploadedFileEvent(
                                    key: entity.id,
                                    fileIndex: entry.key,
                                  ),
                                );
                          },
                        ),
                      ),
                ],
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
      },
    );
  }
}

class _FileStatusTile extends StatelessWidget {
  final SingleFileState fileState;
  final VoidCallback onRemove;

  const _FileStatusTile({required this.fileState, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(_leadingIcon, color: _borderColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileState.fileName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: ColorManager.darkGreen,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  fileState.errorMessage ?? _statusText,
                  style: TextStyle(fontSize: 11, color: _borderColor),
                ),
              ],
            ),
          ),
          if (fileState.status == FileUploadStatus.uploading)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: ColorManager.brown,
              ),
            )
          else
            GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: ColorManager.red.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded,
                    color: ColorManager.red, size: 14),
              ),
            ),
        ],
      ),
    );
  }

  IconData get _leadingIcon => switch (fileState.status) {
        FileUploadStatus.uploading => Icons.upload_outlined,
        FileUploadStatus.success => Icons.check_circle_outline_rounded,
        FileUploadStatus.failure => Icons.error_outline_rounded,
        _ => Icons.insert_drive_file_outlined,
      };

  String get _statusText => switch (fileState.status) {
        FileUploadStatus.uploading => 'جارٍ الرفع...',
        FileUploadStatus.success => 'تم الرفع بنجاح',
        FileUploadStatus.failure => 'فشل الرفع',
        _ => '',
      };

  Color get _borderColor => switch (fileState.status) {
        FileUploadStatus.uploading => ColorManager.brown,
        FileUploadStatus.success => ColorManager.darkGreen,
        FileUploadStatus.failure => ColorManager.red,
        _ => ColorManager.brown,
      };
}