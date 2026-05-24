import 'package:citzenapp/core/error/faliure.dart';
import 'package:citzenapp/feature/auth/otp/data/model/modelOtp.dart';
import 'package:citzenapp/feature/auth/otp/domain/entity/entityOtp.dart';
import 'package:citzenapp/feature/auth/otp/domain/repo/repootp.dart';
import 'package:citzenapp/feature/auth/register/domain/entity/entity.dart';
import 'package:dartz/dartz.dart';

class OTpUseCase {
  final OtpRepo repository;

  OTpUseCase(this.repository);

  Future<Either<Failure, UserEntity>>
      call({
    required OtpModel otp
  }) async {

    return await repository.OtpStep(
      otp: otp
    
    );
  }
}