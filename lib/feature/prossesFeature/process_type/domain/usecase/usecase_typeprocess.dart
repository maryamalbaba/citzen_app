import 'package:dartz/dartz.dart';

import '../../../../../core/error/faliure.dart';

import '../entity/entity.dart';
import '../repo/repo_type.dart';

class GetTypeProcessUseCase {

  final GEtTypeProcess repository;

  GetTypeProcessUseCase(
    this.repository,
  );

  Future<Either<
      Failure,
      List<TypeProcessEntity>
  >> call() async {

    return await repository
        .GetTypeProcss();
  }
}