import 'package:citzenapp/core/error/exception.dart';
import 'package:citzenapp/core/error/faliure.dart';
import 'package:dartz/dartz.dart';

import 'package:citzenapp/feature/prossesFeature/stage_config/data/datasources/document_template_remote_datasource.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/template_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/repositories/document_template_repository.dart';

class DocumentTemplateRepositoryImpl implements DocumentTemplateRepository {
  final DocumentTemplateRemoteDataSource remoteDataSource;

  DocumentTemplateRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, TemplateEntity>> getTemplate(int id) async {
    try {
      final model = await remoteDataSource.getTemplate(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }
}