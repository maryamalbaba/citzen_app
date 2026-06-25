import 'package:citzenapp/core/error/exception.dart';
import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/datasources/submit_form_remote_datasource.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/submit_form_model.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/submit_form_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/repositories/submit_form_repository.dart';
import 'package:dartz/dartz.dart';

class SubmitFormRepositoryImpl implements SubmitFormRepository {
  final SubmitFormRemoteDataSource remoteDataSource;

  SubmitFormRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> submitForm({
    required int processId,
    required SubmitFormEntity entity,
  }) async {
    try {
      await remoteDataSource.submitForm(
        processId: processId,
        body: SubmitFormModel.toJson(entity),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }
}