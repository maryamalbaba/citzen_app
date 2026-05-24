import 'package:citzenapp/feature/auth/otp/domain/usecase/otpUsecase.dart';
import 'package:citzenapp/feature/auth/otp/presentation/bloc/otp_event.dart';
import 'package:citzenapp/feature/auth/otp/presentation/bloc/otp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final OTpUseCase otpUseCase;

  OtpBloc(this.otpUseCase) : super(OtpInitial()) {
    on<VerifyOtpEvent>(_verifyOtp);
  }

  Future<void> _verifyOtp(
    VerifyOtpEvent event,
    Emitter<OtpState> emit,
  ) async {
    emit(OtpLoading());

    final result = await otpUseCase(
      otp: event.otp,
    );

    result.fold(
      (failure) {
        emit(
          OtpError(
            failure.message,
          ),
        );
      },
      (success) {
        emit(
          OtpSuccess(success),
        );
      },
    );
  }
}
