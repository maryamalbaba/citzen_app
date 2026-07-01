import 'package:dartz/dartz.dart';

abstract class LogoutRepository {
  Future<Either<Exception, bool>> logout();
}