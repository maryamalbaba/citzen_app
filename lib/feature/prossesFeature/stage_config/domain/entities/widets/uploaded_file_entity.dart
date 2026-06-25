class UploadedFileEntity {
  final String key;        // national_id_files
  final String path;       // /uploads/...
  final String url;        // https://...
  final String originalName;
  final String mimeType;
  final int typeDocId;

  const UploadedFileEntity({
    required this.key,
    required this.path,
    required this.url,
    required this.originalName,
    required this.mimeType,
    required this.typeDocId,
  });
}