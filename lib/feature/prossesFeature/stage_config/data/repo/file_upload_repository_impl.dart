import 'package:citzenapp/core/error/exception.dart';
import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/datasources/file_upload_remote_datasource.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/uploaded_file_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/repositories/file_upload_repository.dart';
import 'package:dartz/dartz.dart';
class FileUploadRepositoryImpl implements FileUploadRepository {
  final FileUploadRemoteDataSource remoteDataSource;

  FileUploadRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UploadedFileEntity>> uploadFile({
    required String filePath,
    required String fileName,
    required int typeDocId,
    required String key,
  }) async {
    try {
      final model = await remoteDataSource.uploadFile(
        filePath: filePath,
        fileName: fileName,
        typeDocId: typeDocId,
        key: key,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }
}