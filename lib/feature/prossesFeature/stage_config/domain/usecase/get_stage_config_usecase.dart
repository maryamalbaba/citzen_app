import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/form_config_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/repositories/stage_config_repository.dart';
import 'package:dartz/dartz.dart';

class GetStageConfigUseCase {
  final StageConfigRepository repository;

  GetStageConfigUseCase(this.repository);

  Future<Either<Failure, FormConfigEntity>> call(int id) {
    return repository.getStageConfig(id);
  }
}