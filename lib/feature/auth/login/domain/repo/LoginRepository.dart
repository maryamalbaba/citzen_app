// login_repository_impl.dart
import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/auth/login/data/data_source/LoginRemoteDataSource.dart';
import 'package:citzenapp/feature/auth/login/data/models/LoginResponseModel.dart';
import 'package:dartz/dartz.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginResponseModel>> login({required String userName, required String password});
}

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, LoginResponseModel>> login({required String userName, required String password}) async {
    try {
      final response = await remoteDataSource.login(userName: userName, password: password);

      if (response['success'] == true) {
        final data = LoginResponseModel.fromMap(response['data']);
        return Right(data);
      } else {
        return Left(ServerFailure(response['message'] ?? 'حدث خطأ ما'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}