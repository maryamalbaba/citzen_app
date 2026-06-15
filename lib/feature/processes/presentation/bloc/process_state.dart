import 'package:citzenapp/feature/processes/data/models/auth_process_model.dart';


enum AuthProcessStatus { initial, loading, success, failure }

class AuthProcessState {
  final AuthProcessStatus status;
  final List<AuthProcessModel> processes;
  final String errorMessage;
  final int currentPage;
  final bool hasNextPage;
  final bool isLoadingMore; // لعرض مؤشر تحميل صغير أسفل القائمة أثناء جلب الصفحة الجديدة

  AuthProcessState({
    this.status = AuthProcessStatus.initial,
    this.processes = const [],
    this.errorMessage = '',
    this.currentPage = 1,
    this.hasNextPage = false,
    this.isLoadingMore = false,
  });

  // دالة copyWith لتعديل قيم معينة في الـ State مع الحفاظ على القيم الأخرى في الذاكرة
  AuthProcessState copyWith({
    AuthProcessStatus? status,
    List<AuthProcessModel>? processes,
    String? errorMessage,
    int? currentPage,
    bool? hasNextPage,
    bool? isLoadingMore,
  }) {
    return AuthProcessState(
      status: status ?? this.status,
      processes: processes ?? this.processes,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}