import 'package:citzenapp/feature/auth/otp/data/model/modelOtp.dart';

abstract class OtpRemoteDataSource {
  Future<Map<String, dynamic>> OtpStep({
  required OtpModel otp_model
  });
}
