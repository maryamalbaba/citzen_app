import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/submit_form_entity.dart';
import 'package:dartz/dartz.dart';

import 'package:dartz/dartz.dart';

import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/submit_form_entity.dart';

abstract class SubmitFormRepository {
  Future<Either<Failure, Map<String, dynamic>?>> submitForm({
    required int processId,
    required SubmitFormEntity entity,
  });
}