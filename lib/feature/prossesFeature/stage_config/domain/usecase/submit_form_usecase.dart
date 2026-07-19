import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/submit_form_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/repositories/submit_form_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:dartz/dartz.dart';

import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/submit_form_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/repositories/submit_form_repository.dart';

class SubmitFormUseCase {
  final SubmitFormRepository repository;

  SubmitFormUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>?>> call({
    required int processId,
    required SubmitFormEntity entity,
  }) {
    return repository.submitForm(
      processId: processId,
      entity: entity,
    );
  }
}