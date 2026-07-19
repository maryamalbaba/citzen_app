import 'package:citzenapp/core/error/faliure.dart';
import 'package:dartz/dartz.dart';

import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/template_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/repositories/document_template_repository.dart';

class GetDocumentTemplateUseCase {
  final DocumentTemplateRepository repository;

  GetDocumentTemplateUseCase(this.repository);

  Future<Either<Failure, TemplateEntity>> call(int id) {
    return repository.getTemplate(id);
  }
}