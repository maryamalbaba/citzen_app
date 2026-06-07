// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:citzenapp/core/resource/baseurl.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/reqestType.dart';
import 'package:citzenapp/feature/auth/otp/data/model/modelOtp.dart';
import 'package:citzenapp/feature/auth/otp/data/source/remotImpl.dart';

class remotOtpImpl extends OtpRemoteDataSource {
  final ApiConsumer api;
  remotOtpImpl({
    required this.api,
  });

  @override
  Future<Map<String, dynamic>> OtpStep({required OtpModel otp_model}) async {
    final response = await api.request(
        path: url.otp,
        method: RequestType.post,
        data: otp_model.toMap());
    return response;
  }
}
