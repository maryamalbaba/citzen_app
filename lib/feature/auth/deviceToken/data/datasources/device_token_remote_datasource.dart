
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/reqestType.dart';   

abstract class DeviceTokenRemoteDataSource {
  Future<void> registerDeviceToken({
    required String fcmToken,
    required String deviceId,
    required String platform,
  });
}

class DeviceTokenRemoteDataSourceImpl implements DeviceTokenRemoteDataSource {
  final ApiConsumer apiConsumer;

  DeviceTokenRemoteDataSourceImpl(this.apiConsumer);

  @override
  Future<void> registerDeviceToken({
    required String fcmToken,
    required String deviceId,
    required String platform,
  }) async {
    // سيقوم AuthInterceptor تلقائياً بإضافة Bearer Token في الهيدر
    await apiConsumer.request(
      path: '/api/auth/device-token', // تأكدي إن كان الباث يتطلب /api/auth/device-token أو حسب baseUrl لديكِ
      method: RequestType.post,
      data: {
        'fcm_token': fcmToken,
        'platform': platform,
        'device_id': deviceId,
      },
    );
  }
}