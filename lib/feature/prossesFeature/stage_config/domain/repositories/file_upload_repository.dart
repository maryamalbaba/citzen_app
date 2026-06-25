import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/uploaded_file_entity.dart';
import 'package:dartz/dartz.dart';

abstract class FileUploadRepository {
  Future<Either<Failure, UploadedFileEntity>> uploadFile({
    required String filePath,
    required String fileName,
    required int typeDocId,
    required String key,
  });
}