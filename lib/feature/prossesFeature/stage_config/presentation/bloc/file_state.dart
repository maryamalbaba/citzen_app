import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/uploaded_file_entity.dart';


// حالة ملف واحد أثناء الرفع
enum FileUploadStatus { idle, uploading, success, failure }

class SingleFileState {
  final String fileName;
  final FileUploadStatus status;
  final UploadedFileEntity? uploadedEntity; // النتيجة بعد النجاح
  final String? errorMessage;

  const SingleFileState({
    required this.fileName,
    required this.status,
    this.uploadedEntity,
    this.errorMessage,
  });

  SingleFileState copyWith({
    FileUploadStatus? status,
    UploadedFileEntity? uploadedEntity,
    String? errorMessage,
  }) {
    return SingleFileState(
      fileName: fileName,
      status: status ?? this.status,
      uploadedEntity: uploadedEntity ?? this.uploadedEntity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class FileUploadState {
  // key = id الحقل (مثل national_id_files)
  // value = قائمة ملفات هذا الحقل
  final Map<String, List<SingleFileState>> filesPerField;

  const FileUploadState({
    this.filesPerField = const {},
  });

  FileUploadState copyWith({
    Map<String, List<SingleFileState>>? filesPerField,
  }) {
    return FileUploadState(
      filesPerField: filesPerField ?? this.filesPerField,
    );
  }

  // للـ submit: يرجع فقط الملفات التي رُفعت بنجاح لحقل معين
  List<UploadedFileEntity> getSuccessfulUploads(String fieldKey) {
    return (filesPerField[fieldKey] ?? [])
        .where((f) => f.status == FileUploadStatus.success)
        .map((f) => f.uploadedEntity!)
        .toList();
  }
}