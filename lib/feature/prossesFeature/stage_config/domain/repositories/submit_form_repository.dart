import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/submit_form_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SubmitFormRepository {
  Future<Either<Failure, void>> submitForm({
    required int processId,
    required SubmitFormEntity entity,
  });
}