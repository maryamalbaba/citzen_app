import 'package:citzenapp/feature/auth/logout/data/source/remote.dart';
import 'package:citzenapp/feature/auth/logout/domain/repo/repo.dart';

import 'package:dartz/dartz.dart';

class LogoutUseCase {
  final LogoutRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Exception, bool>> call() async {
    return await repository.logout();
  }
}