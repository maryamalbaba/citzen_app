import 'package:citzenapp/core/service/utils/device_info_helper.dart';
import 'package:citzenapp/feature/auth/deviceToken/data/datasources/device_token_remote_datasource.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationDeviceService {
  final DeviceTokenRemoteDataSource remoteDataSource;

  NotificationDeviceService(this.remoteDataSource);

  /// 1. دالة المزامنة الرئيسية
  Future<void> syncDeviceTokenWithServer() async {
    try {
      // جلب رمز FCM الحالي
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        print("⚠️ FCM Token is null or empty, skipping sync.");
        return;
      }

      String deviceId = await DeviceInfoHelper.getDeviceId();
      String platform = DeviceInfoHelper.getPlatformName();

      print("🚀 Syncing Device Token: $fcmToken for Device: $deviceId");

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

  /// 2. الاستماع لتغير الـ Token من الفايربيز وتحديثه تلقائياً
  void initTokenRefreshListener() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newFcmToken) async {
      print("🔄 FCM Token refreshed by Google: $newFcmToken");
      await syncDeviceTokenWithServer();
    });
  }
}