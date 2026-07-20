import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

/// جلب الإشعارات (الصفحة الأولى) أو إعادة التحديث
class FetchNotificationsEvent extends NotificationsEvent {
  final bool? unread;

  const FetchNotificationsEvent({this.unread});

  @override
  List<Object?> get props => [unread];
}

/// جلب الصفحة التالية عند التمرير لأسفل (Pagination)
class FetchMoreNotificationsEvent extends NotificationsEvent {}

/// تغيير الفلتر بين (عرض الكل / غير المقروء فقط)
class ToggleUnreadFilterEvent extends NotificationsEvent {
  final bool unreadOnly;

  const ToggleUnreadFilterEvent({required this.unreadOnly});

  @override
  List<Object?> get props => [unreadOnly];
}