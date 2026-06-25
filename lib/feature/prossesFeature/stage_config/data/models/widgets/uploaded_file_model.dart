
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/uploaded_file_entity.dart';

class UploadedFileModel {
  final String key;
  final String path;
  final String url;
  final String originalName;
  final String mimeType;
  final int typeDocId;

  const UploadedFileModel({
    required this.key,
    required this.path,
    required this.url,
    required this.originalName,
    required this.mimeType,
    required this.typeDocId,
  });

  factory UploadedFileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return UploadedFileModel(
      key: data['key'] as String,
      path: data['path'] as String,
      url: data['url'] as String,
      originalName: data['original_name'] as String,
      mimeType: data['mime_type'] as String,
      typeDocId: data['type_doc_id'] as int,
    );
  }

  UploadedFileEntity toEntity() {
    return UploadedFileEntity(
      key: key,
      path: path,
      url: url,
      originalName: originalName,
      mimeType: mimeType,
      typeDocId: typeDocId,
    );
  }
}