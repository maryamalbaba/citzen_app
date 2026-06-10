import 'package:citzenapp/feature/auth/resendotp/data/model/resendotpmodel.dart';
import 'package:citzenapp/feature/auth/resendotp/data/source/remote.dart';

abstract class ResendOtpRepository {
  Future<ResendOtpResponseModel> resendOtp(String oldSessionId);
}

class ResendOtpRepositoryImpl implements ResendOtpRepository {
  final ResendOtpRemoteDataSource remoteDataSource;

  ResendOtpRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ResendOtpResponseModel> resendOtp(String oldSessionId) async {
    return await remoteDataSource.resendOtp(oldSessionId);
  }
}