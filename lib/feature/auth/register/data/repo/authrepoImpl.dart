import 'package:citzenapp/core/error/exception.dart';
import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/core/service/Token/tokenStorage.dart';
import 'package:citzenapp/feature/auth/register/data/model/registerresponse_model.dart';
import 'package:citzenapp/feature/auth/register/data/model/requestmodel.dart';

import 'package:citzenapp/feature/auth/register/data/source/remote_data_source.dart';
import 'package:citzenapp/feature/auth/register/domain/entity/register_response.dart';
import 'package:citzenapp/feature/auth/register/domain/repo/auth_repository.dart';

import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remote,
    required this.tokenStorage,
  });
  @override
  Future<Either<Failure, RegisterResponseEntity>> registerCitizen({
    required RegisterRequestModel user,
  }) async {
    try {
      final response = await remote.registerCitizen(
        user: user,
      );

      /// check success
      if (response['success'] != true) {
        return Left(
          ServerFailure(
            response['message'] ?? 'حدث خطأ غير معروف',
          ),
        );
      }

      /// response model
      final registerResponse = RegisterResponseModel.fromMap(
        response['data'],
      );

      return Right(
        registerResponse,
      );
    } on UnauthorizedException catch (e) {
      return Left(
        UnauthorizedFailure(e.message),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(e.message),
      );
    } catch (e) {
      print(
        'REGISTER ERROR => $e',
      );

      return Left(
        ServerFailure(
          e.toString(),
        ),
      );
    }
  }
}
