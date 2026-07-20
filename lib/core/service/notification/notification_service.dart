import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// دالة التعامل مع الإشعارات في الخلفية يجب أن تكون خارج أي كلاس
@pragma('vm:entry-point')
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future initializeNotifications() async {
    // 1. طلب صلاحية إرسال الإشعارات من المستخدم (مهم جداً للـ iOS والأندرويد الحديث)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      
      // 2. الحصول على الـ Token الخاص بالجهاز لإرسال إشعارات مخصصة لاحقاً
      String? token = await _messaging.getToken();
      print("Firebase Device Token: $token");

      // 3. إعداد دالة التعامل مع الإشعارات في الخلفية (Background)
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // 4. التعامل مع الإشعارات والتطبيق مفتوح (Foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        if (message.notification != null) {
          print('Message Title: ${message.notification!.title}');
          print('Message Body: ${message.notification!.body}');
          // هنا يمكن إضافة شريط تنبيه (SnackBar) أو تنبيه مخصص داخل التطبيق
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }
}