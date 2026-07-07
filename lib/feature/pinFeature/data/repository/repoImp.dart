import 'package:citzenapp/core/error/exception.dart';
import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/pinFeature/data/source/local.dart';
import 'package:citzenapp/feature/pinFeature/data/source/remote.dart';
import 'package:citzenapp/feature/pinFeature/domin/entity/messageentity.dart';
import 'package:citzenapp/feature/pinFeature/domin/entity/pin_verevicationEntity.dart';
import 'package:citzenapp/feature/pinFeature/domin/repository/repo.dart';
import 'package:dartz/dartz.dart';

class PinRepositoryImpl implements PinRepository {
  final PinRemoteDataSource remoteDataSource;
  final PinLocalDataSource localDataSource;

  PinRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, PinMessage>> setupPin({
    required String pin,
    required String confirmPin,
  }) async {
    try {
      final result = await remoteDataSource.setupPin(
        pin: pin,
        confirmPin: confirmPin,
      );
      // بعد نجاح الإنشاء فعلياً على السيرفر، نُفعّل العلامة المحلية
      // كي يعرف التطبيق أن عليه عرض شاشة التحقق لاحقاً عند الفتح.
      await localDataSource.setPinCreated(true);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('حدث خطأ غير متوقع أثناء إنشاء رمز PIN'));
    }
  }

  @override
  Future<Either<Failure, PinVerificationResult>> verifyPin({
    required String pin,
  }) async {
    try {
      final result = await remoteDataSource.verifyPin(pin: pin);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('حدث خطأ غير متوقع أثناء التحقق من رمز PIN'));
    }
  }

  @override
  Future<Either<Failure, PinMessage>> changePin({
    required String oldPin,
    required String newPin,
    required String confirmNewPin,
  }) async {
    try {
      final result = await remoteDataSource.changePin(
        oldPin: oldPin,
        newPin: newPin,
        confirmNewPin: confirmNewPin,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('حدث خطأ غير متوقع أثناء تغيير رمز PIN'));
    }
  }

  @override
  Future<bool> hasPinCreated() {
    return localDataSource.isPinCreated();
  }

  @override
  Future<void> clearLocalPinState() {
    return localDataSource.clearPinFlag();
  }
}
