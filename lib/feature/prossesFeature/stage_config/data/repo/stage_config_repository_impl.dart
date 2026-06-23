import 'package:citzenapp/core/error/exception.dart';
import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/datasources/stage_config_remote_datasource.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/form_config_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/repositories/stage_config_repository.dart';
import 'package:dartz/dartz.dart';

class StageConfigRepositoryImpl implements StageConfigRepository {
  final StageConfigRemoteDataSource remoteDataSource;

  StageConfigRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, FormConfigEntity>> getStageConfig(int id) async {
    try {
      final model = await remoteDataSource.getStageConfig(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }
}