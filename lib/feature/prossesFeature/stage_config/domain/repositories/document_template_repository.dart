import 'package:citzenapp/core/error/faliure.dart';
import 'package:dartz/dartz.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/template_entity.dart';

abstract class DocumentTemplateRepository {
  Future<Either<Failure, TemplateEntity>> getTemplate(int id);
}