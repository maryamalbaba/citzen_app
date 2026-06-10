import 'package:citzenapp/feature/auth/resendotp/domain/usecase/resendusecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'resend_otp_event.dart';
import 'resend_otp_state.dart';

class ResendOtpBloc extends Bloc<ResendOtpEvent, ResendOtpState> {
  final ResendOtpUseCase resendOtpUseCase;

  ResendOtpBloc(this.resendOtpUseCase) : super(ResendOtpInitial()) {
    on<TriggerResendOtpEvent>((event, emit) async {
      emit(ResendOtpLoading());
      try {
        final result = await resendOtpUseCase.call(event.oldSessionId);
        emit(ResendOtpSuccess(response: result));
      } catch (e) {
        emit(ResendOtpError(message: e.toString()));
      }
    });
  }
}