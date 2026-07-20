import 'notification_item_model.dart';
import 'pagination_model.dart';

class NotificationsResponseModel {
  final List<NotificationItemModel> items;
  final PaginationModel pagination;
  final int unreadCount;

  NotificationsResponseModel({
    required this.items,
    required this.pagination,
    required this.unreadCount,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationsResponseModel(
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => NotificationItemModel.fromJson(item))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}