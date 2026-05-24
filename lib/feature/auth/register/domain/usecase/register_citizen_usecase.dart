import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/auth/register/data/model/requestmodel.dart';
import 'package:citzenapp/feature/auth/register/data/model/user_model.dart';
import 'package:citzenapp/feature/auth/register/domain/entity/register_response.dart';
import 'package:citzenapp/feature/auth/register/domain/repo/auth_repository.dart';
import 'package:citzenapp/feature/auth/register/domain/entity/entity.dart';
import 'package:dartz/dartz.dart';

class RegisterCitizenUseCase {
  final AuthRepository repository;

  RegisterCitizenUseCase(this.repository);

  Future<Either<Failure, RegisterResponseEntity>>
      call({
    required RegisterRequestModel user
  }) async {

    return await repository.registerCitizen(
      user: user
    
    );
  }
}