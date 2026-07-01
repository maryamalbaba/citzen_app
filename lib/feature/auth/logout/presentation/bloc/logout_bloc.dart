import 'package:citzenapp/feature/auth/logout/domain/usecase/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutBloc({required this.logoutUseCase}) : super(LogoutInitial()) {
    on<LogoutSubmitted>(_onLogoutSubmitted);
  }

  Future<void> _onLogoutSubmitted(
    LogoutSubmitted event,
    Emitter<LogoutState> emit,
  ) async {
    emit(LogoutLoading());

    final result = await logoutUseCase();

    result.fold(
      (exception) => emit(LogoutFailure(exception.toString())),
      (success) => emit(LogoutSuccess()),
    );
  }
}