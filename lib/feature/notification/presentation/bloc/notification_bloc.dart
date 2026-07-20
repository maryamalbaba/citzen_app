import 'package:citzenapp/feature/notification/domain/repo/usecase/get_notifications_usecase.dart';
import 'package:citzenapp/feature/notification/presentation/bloc/notification_event.dart';
import 'package:citzenapp/feature/notification/presentation/bloc/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;

  NotificationsBloc({required this.getNotificationsUseCase})
      : super(NotificationsInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<FetchMoreNotificationsEvent>(_onFetchMoreNotifications);
    on<ToggleUnreadFilterEvent>(_onToggleUnreadFilter);
  }

  /// 1. جلب الصفحة الأولى
  Future<void> _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());

    try {
      final response = await getNotificationsUseCase.call(
        cursor: null, // البداية من أول صفحة
        limit: 10,
        unread: event.unread,
      );

      emit(NotificationsLoaded(
        items: response.items,
        nextCursor: response.pagination.nextCursor,
        hasNext: response.pagination.hasNext,
        unreadCount: response.unreadCount,
        unreadFilter: event.unread ?? false,
      ));
    } catch (e) {
      emit(NotificationsError(message: e.toString()));
    }
  }

  /// 2. جلب الصفحة التالية (Cursor Pagination)
  Future<void> _onFetchMoreNotifications(
    FetchMoreNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    final currentState = state;

    // شروط الأمان: نضمن وجود حالة loaded وأن هناك صفحة تالية وأننا لا نحمل حالياً
    if (currentState is NotificationsLoaded) {
      if (!currentState.hasNext ||
          currentState.nextCursor == null ||
          currentState.isLoadingMore) {
        return; // لا توجد صفحات إضافية أو جارٍ التحميل بالفعل
      }

      // تفعيل مؤشر التحميل السفلي
      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final response = await getNotificationsUseCase.call(
          cursor: currentState.nextCursor, // إرسال المؤشر المستلم سابقاً
          limit: 10,
          unread: currentState.unreadFilter ? true : null,
        );

        // دمج القائمة القديمة مع العناصر الجديدة القادمة من الباك إند
        final updatedList = List.of(currentState.items)..addAll(response.items);

        emit(currentState.copyWith(
          items: updatedList,
          nextCursor: response.pagination.nextCursor,
          hasNext: response.pagination.hasNext,
          unreadCount: response.unreadCount,
          isLoadingMore: false,
        ));
      } catch (e) {
        // في حال فشل تحميل المزيد نحافظ على القائمة الحالية ونوقف المؤشر
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }

  /// 3. تغيير الفلتر (غير المقروء فقط / الكل)
  Future<void> _onToggleUnreadFilter(
    ToggleUnreadFilterEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    add(FetchNotificationsEvent(
      unread: event.unreadOnly ? true : null,
    ));
  }
}