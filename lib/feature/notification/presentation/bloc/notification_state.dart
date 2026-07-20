import 'package:equatable/equatable.dart';
import '../../data/models/notification_item_model.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class NotificationsInitial extends NotificationsState {}

/// حالة التحميل لأول مرة
class NotificationsLoading extends NotificationsState {}

/// حالة النجاح وعرض البيانات
class NotificationsLoaded extends NotificationsState {
  final List<NotificationItemModel> items;
  final String? nextCursor;
  final bool hasNext;
  final int unreadCount;
  final bool isLoadingMore; // هل يجري تحميل الصفحة التالية حالياً؟
  final bool unreadFilter;  // هل الفلتر المفعل هو "غير المقروء فقط"؟

  const NotificationsLoaded({
    required this.items,
    this.nextCursor,
    required this.hasNext,
    required this.unreadCount,
    this.isLoadingMore = false,
    this.unreadFilter = false,
  });

  NotificationsLoaded copyWith({
    List<NotificationItemModel>? items,
    String? nextCursor,
    bool? hasNext,
    int? unreadCount,
    bool? isLoadingMore,
    bool? unreadFilter,
  }) {
    return NotificationsLoaded(
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
      hasNext: hasNext ?? this.hasNext,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      unreadFilter: unreadFilter ?? this.unreadFilter,
    );
  }

  @override
  List<Object?> get props => [
        items,
        nextCursor,
        hasNext,
        unreadCount,
        isLoadingMore,
        unreadFilter,
      ];
}

/// حالة وجود خطأ في الجلب الأول
class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError({required this.message});

  @override
  List<Object?> get props => [message];
}