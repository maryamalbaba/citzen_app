abstract class AuthProcessEvent {
  const AuthProcessEvent();
}

class FetchAuthProcessesEvent extends AuthProcessEvent {
  final num id;

  // هنا تم تصحيح اسم الـ Constructor ليتطابق مع اسم الكلاس تماماً
  const FetchAuthProcessesEvent({required this.id});
}

class LoadMoreAuthProcessesEvent extends AuthProcessEvent {
  const LoadMoreAuthProcessesEvent();
}