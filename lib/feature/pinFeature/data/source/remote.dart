
import 'package:citzenapp/core/resource/api.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/reqestType.dart';
import 'package:citzenapp/feature/pinFeature/data/model/pinmessag.dart';
import 'package:citzenapp/feature/pinFeature/data/model/pinverification.dart';
import 'package:citzenapp/feature/pinFeature/data/model/url.dart';

abstract class PinRemoteDataSource {
  Future<PinMessageModel> setupPin({
    required String pin,
    required String confirmPin,
  });

  Future<PinVerificationResultModel> verifyPin({required String pin});

  Future<PinMessageModel> changePin({
    required String oldPin,
    required String newPin,
    required String confirmNewPin,
  });
}

/// التنفيذ الفعلي: يستخدم نفس ApiConsumer (DioConsumer) المستخدم في باقي المشروع،
/// وبالتالي يستفيد تلقائياً من AuthInterceptor (إرفاق التوكن + تجديده) ومن
/// ErrorHandler (تحويل أخطاء Dio إلى Exceptions برسائل عربية جاهزة).
class PinRemoteDataSourceImpl implements PinRemoteDataSource {
  final ApiConsumer apiConsumer;

  PinRemoteDataSourceImpl(this.apiConsumer);

  @override
  Future<PinMessageModel> setupPin({
    required String pin,
    required String confirmPin,
  }) async {
    final response = await apiConsumer.request(
      path: PinEndpoints.setupPin,
      method: RequestType.post,
      data: {
        'pin': pin,
        'confirm_pin': confirmPin,
      },
    );
    return PinMessageModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<PinVerificationResultModel> verifyPin({required String pin}) async {
    final response = await apiConsumer.request(
      path: PinEndpoints.verifyAppPin,
      method: RequestType.post,
      data: {
        'pin': pin,
      },
    );
    return PinVerificationResultModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<PinMessageModel> changePin({
    required String oldPin,
    required String newPin,
    required String confirmNewPin,
  }) async {
    final response = await apiConsumer.request(
      path: PinEndpoints.changePin,
      method: RequestType.post,
      data: {
        'old_pin': oldPin,
        'new_pin': newPin,
        'confirm_new_pin': confirmNewPin,
      },
    );
    return PinMessageModel.fromJson(response as Map<String, dynamic>);
  }
}