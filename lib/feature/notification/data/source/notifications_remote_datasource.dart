import 'package:citzenapp/core/service/apiConsumer.dart';

import 'package:citzenapp/core/service/reqestType.dart';
import '../models/notifications_response_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<NotificationsResponseModel> getNotifications({
    String? cursor,
    int limit = 10,
    bool? unread,
  });
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final ApiConsumer apiConsumer;

  NotificationsRemoteDataSourceImpl(this.apiConsumer);

  @override
  Future<NotificationsResponseModel> getNotifications({
    String? cursor,
    int limit = 10,
    bool? unread,
  }) async {
    // 1. تجهيز الـ Query Parameters الممررة في الرابط
    final Map<String, dynamic> queryParameters = {
      'limit': limit,
    };

    // نقتطع الـ cursor فقط إذا كان يحتوي على قيمة (للصفحات التالية)
    if (cursor != null && cursor.isNotEmpty) {
      queryParameters['cursor'] = cursor;
    }

    // نقتطع الـ unread فقط إذا كان محدداً (لتصفية غير المقروء فقط)
    if (unread != null) {
      queryParameters['unread'] = unread;
    }

    // 2. إرسال الطلب لـ API الإشعارات
    final response = await apiConsumer.request(
      path: '/api/notifications/my', // مسار الـ Endpoint
      method: RequestType.get,
      queryParameters: queryParameters,
    );

    // 3. تحويل كائن الـ data الداخلي المستلم إلى NotificationsResponseModel
    return NotificationsResponseModel.fromJson(response['data']);
  }
}