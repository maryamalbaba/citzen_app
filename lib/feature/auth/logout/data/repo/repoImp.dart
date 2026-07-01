import 'package:citzenapp/core/service/Token/tokenStorage.dart';
import 'package:citzenapp/feature/auth/logout/data/source/remote.dart';
import 'package:citzenapp/feature/auth/logout/domain/repo/repo.dart';


import 'package:dartz/dartz.dart';

class LogoutRepositoryImp implements LogoutRepository {
  final LogoutRemoteDataSourceImpl remoteDataSource;
  final TokenStorage tokenStorage;

  LogoutRepositoryImp({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<Either<Exception, bool>> logout() async {
    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      
      if (refreshToken != null) {
        // 1. Notify Remote Backend Server to revoke token reference
        await remoteDataSource.logout(refreshToken: refreshToken);
      }
      
      // 2. Clear out local Secure Storage safely 
      await tokenStorage.clearTokens();
      
      return const Right(true);
    } catch (e) {
      // Graceful local cleanup even if the backend drop request encounters network failures
      await tokenStorage.clearTokens();
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }
}