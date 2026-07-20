import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  /// 1. قناة الإشعارات ذات الأولوية القصوى (للنغمة والظهور المنبثق في أندرويد)
  static const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
    'high_importance_channel', // نفس ID القناة المكتوب في AndroidManifest.xml
    'إشعارات مهمة', // اسم القناة المكتوب بالنظام
    description: 'تُستخدم لإظهار الإشعارات العاجلة والهامة مع الصوت.',
    importance: Importance.max, // أولوية قصوى للظهور المنبثق أعلى الشاشة
    playSound: true,
    enableVibration: true,
  );

  static Future<void> initialize() async {
    // أ. طلب الصلاحيات من المستخدم (Android 13+ & iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print('🔔 User notification permission status: ${settings.authorizationStatus}');

    // ب. تفعيل إظهار الإشعارات والصوت في نظام iOS عند فتح التطبيق
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // ج. تهيئة إعدادات أندرويد للإشعارات المحلية
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(initSettings);

    // د. إنشاء قناة أندرويد للأولوية القصوى
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(_androidChannel);
    }

    // هـ. الاستماع للإشعارات القادمة والتطبيق مفتوح (Foreground)
   // هـ. الاستماع للإشعارات القادمة والتطبيق مفتوح (Foreground)
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('📩 Received foreground message from backend: ${message.data}');

  // 1. استخراج العنوان والرسالة سواء أرسلها الباك إند كـ notification أو data
  String? title = message.notification?.title ?? message.data['title'];
  String? body = message.notification?.body ?? 
                  message.data['message'] ?? 
                  message.data['body'];

  // 2. إظهار الإشعار المحلي فوراً بالنغمة والنافذة المنبثقة
  if (title != null && body != null) {
    _localNotifications.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
      ),
    );
  }
});
  }
}