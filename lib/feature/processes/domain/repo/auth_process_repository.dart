import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/processes/data/models/auth_process_model.dart';
import 'package:dartz/dartz.dart'; 


abstract class AuthProcessRepository {
  Future<Either<Failure, ProcessAuthResponse>> getAuthProcesses({
    required num id,
    required int page,
    required int limit,
  });
}