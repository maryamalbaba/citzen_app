// login_usecase.dart
import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/auth/login/data/models/LoginResponseModel.dart';
import 'package:citzenapp/feature/auth/login/domain/repo/LoginRepository.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, LoginResponseModel>> call({required String userName, required String password}) async {
    return await repository.login(userName: userName, password: password);
  }
}