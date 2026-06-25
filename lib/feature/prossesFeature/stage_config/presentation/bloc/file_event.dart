import 'package:file_picker/file_picker.dart';

abstract class FileUploadEvent {
  const FileUploadEvent();
}

class UploadFileEvent extends FileUploadEvent {
  final PlatformFile file;
  final int typeDocId;
  final String key; // id الحقل من الـ entity

  const UploadFileEvent({
    required this.file,
    required this.typeDocId,
    required this.key,
  });
}

class RemoveUploadedFileEvent extends FileUploadEvent {
  final String key;
  final int fileIndex;

  const RemoveUploadedFileEvent({
    required this.key,
    required this.fileIndex,
  });
}