import 'package:citzenapp/core/service/utils/device_info_helper.dart';
import 'package:citzenapp/feature/auth/deviceToken/data/datasources/device_token_remote_datasource.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationDeviceService {
  final DeviceTokenRemoteDataSource remoteDataSource;

  NotificationDeviceService(this.remoteDataSource);

  Future<void> syncDeviceTokenWithServer() async {
    try {
      // 1. جلب رمز FCM
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) {
        print("⚠️ FCM Token is null, skipping device token registration.");
        return;
      }

      // 2. جلب معرّف الجهاز والمنصة
      String deviceId = await DeviceInfoHelper.getDeviceId();
      String platform = DeviceInfoHelper.getPlatformName();

      // 3. إرسال البيانات للـ API
      await remoteDataSource.registerDeviceToken(
        fcmToken: fcmToken,
        deviceId: deviceId,
        platform: platform,
      );

      print("✅ Device Token synced successfully with Backend!");
    } catch (e) {
      print("❌ Failed to sync Device Token: $e");
    }
  }
}