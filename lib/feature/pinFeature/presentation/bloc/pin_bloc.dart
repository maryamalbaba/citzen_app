import 'package:citzenapp/feature/pinFeature/domin/usecase/changepin.dart';
import 'package:citzenapp/feature/pinFeature/domin/usecase/checkpinStatus.dart';
import 'package:citzenapp/feature/pinFeature/domin/usecase/setupPin.dart';
import 'package:citzenapp/feature/pinFeature/domin/usecase/verifypin.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pin_event.dart';
part 'pin_state.dart';

class PinBloc extends Bloc<PinEvent, PinState> {
  final SetupPinUseCase setupPinUseCase;
  final VerifyPinUseCase verifyPinUseCase;
  final ChangePinUseCase changePinUseCase;
  final CheckPinStatusUseCase checkPinStatusUseCase;

  PinBloc({
    required this.setupPinUseCase,
    required this.verifyPinUseCase,
    required this.changePinUseCase,
    required this.checkPinStatusUseCase,
  }) : super(const PinInitial()) {
    on<CheckPinStatusRequested>(_onCheckPinStatus);
    on<SetupPinRequested>(_onSetupPin);
    on<VerifyPinRequested>(_onVerifyPin);
    on<ChangePinRequested>(_onChangePin);
    on<PinStateReset>((event, emit) => emit(const PinInitial()));
  }

  Future<void> _onCheckPinStatus(
    CheckPinStatusRequested event,
    Emitter<PinState> emit,
  ) async {
    emit(const PinStatusChecking());
    final hasPin = await checkPinStatusUseCase();
    emit(PinStatusChecked(hasPin));
  }

  Future<void> _onSetupPin(
    SetupPinRequested event,
    Emitter<PinState> emit,
  ) async {
    emit(const PinSetupLoading());
    final result = await setupPinUseCase(
      SetupPinParams(pin: event.pin, confirmPin: event.confirmPin),
    );
    result.fold(
      (failure) => emit(PinSetupFailure(failure.message)),
      (success) => emit(PinSetupSuccess(success.message)),
    );
  }

  Future<void> _onVerifyPin(
    VerifyPinRequested event,
    Emitter<PinState> emit,
  ) async {
    emit(const PinVerifyLoading());
    final result = await verifyPinUseCase(VerifyPinParams(pin: event.pin));
    result.fold(
      (failure) => emit(PinVerifyFailure(failure.message)),
      (success) => emit(PinVerifySuccess(success.message)),
    );
  }

  Future<void> _onChangePin(
    ChangePinRequested event,
    Emitter<PinState> emit,
  ) async {
    emit(const PinChangeLoading());
    final result = await changePinUseCase(
      ChangePinParams(
        oldPin: event.oldPin,
        newPin: event.newPin,
        confirmNewPin: event.confirmNewPin,
      ),
    );
    result.fold(
      (failure) => emit(PinChangeFailure(failure.message)),
      (success) => emit(PinChangeSuccess(success.message)),
    );
  }
}
