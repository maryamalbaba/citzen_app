import 'package:citzenapp/core/error/exception.dart';
import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/prossesFeature/processes/data/models/auth_process_model.dart';
import 'package:citzenapp/feature/prossesFeature/processes/data/source/auth_process_remote_data_source.dart';
import 'package:citzenapp/feature/prossesFeature/processes/domain/repo/auth_process_repository.dart';
import 'package:dartz/dartz.dart';

class AuthProcessRepositoryImpl implements AuthProcessRepository {
  final AuthProcessRemoteDataSource remoteDataSource;

  AuthProcessRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProcessAuthResponse>> getAuthProcesses({
    required num id,
    required int page,
    required int limit,
  }) async {
    try {
      final remoteData = await remoteDataSource.getAuthProcesses(
        id: id,
        page: page,
        limit: limit,
      );
      return Right(remoteData);
    } on ServerException catch (e) {
      // هنا نقوم بتمرير الـ Failure بناءً على نظام الأخطاء الخاص بكِ
      return Left(ServerFailure( e.message)); 
    } catch (e) {
      return Left(ServerFailure( e.toString()));
    }
  }
}