

import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/process_type/domain/entity/entity.dart';
import 'package:dartz/dartz.dart';

abstract class GEtTypeProcess {

  Future<Either<Failure,List<TypeProcessEntity>>>
      GetTypeProcss();
}