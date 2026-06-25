import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/uploaded_file_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/repositories/file_upload_repository.dart';
import 'package:dartz/dartz.dart';

class UploadFileUseCase {
  final FileUploadRepository repository;

  UploadFileUseCase(this.repository);

  Future<Either<Failure, UploadedFileEntity>> call({
    required String filePath,
    required String fileName,
    required int typeDocId,
    required String key,
  }) {
    return repository.uploadFile(
      filePath: filePath,
      fileName: fileName,
      typeDocId: typeDocId,
      key: key,
    );
  }
}