import 'package:citzenapp/core/resource/api.dart';
import 'package:citzenapp/core/service/dioCunsumer.dart';
import 'package:citzenapp/core/service/reqestType.dart';
import 'package:citzenapp/feature/auth/resendotp/data/model/resendotpmodel.dart';

abstract class ResendOtpRemoteDataSource {
  Future<ResendOtpResponseModel> resendOtp(String oldSessionId);
}

class ResendOtpRemoteDataSourceImpl implements ResendOtpRemoteDataSource {
  final DioConsumer api;

  ResendOtpRemoteDataSourceImpl({required this.api});

  @override
  Future<ResendOtpResponseModel> resendOtp(String oldSessionId) async {
    // تعديل المسار (End Point) حسب مواصفات السيرفر لديكِ
    final response = await api.request(
        path: url.resendOtp,
        method: RequestType.post,
        data: {
        'session_id': oldSessionId,
      },
      );
    return ResendOtpResponseModel.fromJson(response);
  }
}