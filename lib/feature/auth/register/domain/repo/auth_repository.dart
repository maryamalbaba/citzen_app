import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/auth/register/data/model/requestmodel.dart';
import 'package:citzenapp/feature/auth/register/data/model/user_model.dart';
import 'package:citzenapp/feature/auth/register/domain/entity/entity.dart';
import 'package:citzenapp/feature/auth/register/domain/entity/register_response.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {

  Future<Either<Failure, RegisterResponseEntity>>
      registerCitizen({
     required RegisterRequestModel user
  });
}