import 'package:citzenapp/feature/prossesFeature/processes/data/models/auth_process_model.dart';
import 'package:citzenapp/feature/prossesFeature/processes/domain/usecase/get_auth_processes_use_case.dart';
import 'package:citzenapp/feature/prossesFeature/processes/presentation/bloc/process_event.dart';
import 'package:citzenapp/feature/prossesFeature/processes/presentation/bloc/process_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AuthProcessBloc extends Bloc<AuthProcessEvent, AuthProcessState> {
  final GetAuthProcessesUseCase getAuthProcessesUseCase;
  
  // سنحتفظ بالـ Process ID هنا لنستخدمه عند طلب الصفحات التالية
  num? _currentProcessId; 
  final int _limit = 10; // حجم الصفحة الواحدة

  AuthProcessBloc(this.getAuthProcessesUseCase) : super(AuthProcessState()) {
    on<FetchAuthProcessesEvent>(_onFetchAuthProcesses);
    on<LoadMoreAuthProcessesEvent>(_onLoadMoreAuthProcesses);
  }

  Future<void> _onFetchAuthProcesses(
    FetchAuthProcessesEvent event,
    Emitter<AuthProcessState> emit,
  ) async {
    _currentProcessId = event.id;
    
    // إشعار الواجهة بالتحميل الأول الصريح
    emit(state.copyWith(status: AuthProcessStatus.loading, processes: []));

    final result = await getAuthProcessesUseCase(
      AuthProcessParams(id: event.id, page: 1, limit: _limit),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthProcessStatus.failure,
        errorMessage: failure.message,
      )),
      (response) => emit(state.copyWith(
        status: AuthProcessStatus.success,
        processes: response.data.items,
        currentPage: 1,
        hasNextPage: response.data.pagination.hasNext,
        isLoadingMore: false,
      )),
    );
  }

  Future<void> _onLoadMoreAuthProcesses(
    LoadMoreAuthProcessesEvent event,
    Emitter<AuthProcessState> emit,
  ) async {
    // شروط التوقف: إذا كنا نحمل بالفعل، أو لا توجد صفحة تالية، أو الـ id غير موجود
    if (state.isLoadingMore || !state.hasNextPage || _currentProcessId == null) return;

    // إشعار الـ UI بأننا نقوم بجلب المزيد أسفل الشاشة دون مسح البيانات الحالية
    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;

    final result = await getAuthProcessesUseCase(
      AuthProcessParams(id: _currentProcessId!, page: nextPage, limit: _limit),
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoadingMore: false)), // نكتفي بإيقاف التحميل في الأسفل
      (response) {
        // دمج القائمة السابقة مع عناصر الصفحة الجديدة
        final updatedProcesses = List<AuthProcessModel>.from(state.processes)
          ..addAll(response.data.items);

        emit(state.copyWith(
          status: AuthProcessStatus.success,
          processes: updatedProcesses,
          currentPage: nextPage,
          hasNextPage: response.data.pagination.hasNext,
          isLoadingMore: false,
        ));
      },
    );
  }
}