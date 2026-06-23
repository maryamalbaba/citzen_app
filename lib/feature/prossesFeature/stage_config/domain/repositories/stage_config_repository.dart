import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/form_config_entity.dart';
import 'package:dartz/dartz.dart';

abstract class StageConfigRepository {
  Future<Either<Failure, FormConfigEntity>> getStageConfig(int id);
}