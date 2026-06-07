// login_bloc.dart
import 'package:citzenapp/feature/auth/login/domain/usecase/usecase.dart';
import 'package:citzenapp/feature/auth/login/presentation/bloc/login_event.dart';
import 'package:citzenapp/feature/auth/login/presentation/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(LoginInitial()) {
    on<SubmitLoginEvent>((event, emit) async {
      emit(LoginLoading());
      
      final result = await loginUseCase(userName: event.userName, password: event.password);
      
      result.fold(
        (failure) => emit(LoginFailure(failure.message)), // حسب تعريف الـ failure عندكِ
        (successModel) => emit(LoginSuccess(successModel)),
      );
    });
  }
}