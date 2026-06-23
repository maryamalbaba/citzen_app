import 'package:citzenapp/core/error/exception.dart';
import 'package:citzenapp/core/error/faliure.dart';

import 'package:citzenapp/feature/prossesFeature/process_type/data/model/type_model.dart';
import 'package:citzenapp/feature/prossesFeature/process_type/data/source/remote_source.dart';
import 'package:citzenapp/feature/prossesFeature/process_type/domain/entity/entity.dart';
import 'package:citzenapp/feature/prossesFeature/process_type/domain/repo/repo_type.dart';
import 'package:dartz/dartz.dart';
import 'package:dartz/dartz.dart';



class TypeProcessImpl implements GEtTypeProcess {
  final GetTypeProcSourceImpl remote;

  TypeProcessImpl({
    required this.remote,
  });
@override
Future<Either<Failure, List<TypeProcessEntity>>>
    GetTypeProcss() async {

  try {

    final response =
        await remote.getTypeRemote();

    /// DATA CHECK
    if (response['data'] == null) {

      return Left(
        response['message'] ??
          'حدث خطأ غير معروف',
      );
    }

    final List data = response['data'];

    /// EMPTY CHECK
    if (data.isEmpty) {

      return Left(
        EmptyDataFailure(
            response['message'] ??
          'لا توجد عمليات متاحة',
     ),
      );
    }

    /// MAPPING
    final result = data
        .map<TypeProcessEntity>(
          (e) => TypeProcModel.fromMap(e),
        )
        .toList();

    return Right(result);

  }

  on UnauthorizedException catch (e) {

    return Left(
      UnauthorizedFailure(
        e.message,
      ),
    );
  }

  on ServerException catch (e) {
  print(
        'type process ERROR => $e',
      );
    return Left(
      ServerFailure(
        e.message,
      ),
    );
  }

  catch (e) {

    return Left(
      ServerFailure(
        e.toString(),
      ),
    );
  }
}}