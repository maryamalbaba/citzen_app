import '../../data/models/notifications_response_model.dart';

abstract class NotificationsRepository {
  Future<NotificationsResponseModel> getNotifications({
    String? cursor,
    int limit = 10,
    bool? unread,
  });
}