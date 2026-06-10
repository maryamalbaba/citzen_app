
import 'package:citzenapp/feature/auth/resendotp/data/model/resendotpmodel.dart';
import 'package:citzenapp/feature/auth/resendotp/data/repo/reporesend.dart';

class ResendOtpUseCase {
  final ResendOtpRepository repository;

  ResendOtpUseCase(ResendOtpRepository resendOtpRepository, {required this.repository});

  Future<ResendOtpResponseModel> call(String oldSessionId) async {
    return await repository.resendOtp(oldSessionId);
  }
}