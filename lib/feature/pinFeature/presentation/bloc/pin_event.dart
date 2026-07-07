part of 'pin_bloc.dart';

abstract class PinEvent extends Equatable {
  const PinEvent();

  @override
  List<Object?> get props => [];
}

/// يُستدعى عند بدء التطبيق (مثلاً في Splash) لمعرفة
/// هل يجب عرض شاشة "إنشاء PIN" أو شاشة "تحقق من PIN".
class CheckPinStatusRequested extends PinEvent {
  const CheckPinStatusRequested();
}

class SetupPinRequested extends PinEvent {
  final String pin;
  final String confirmPin;

  const SetupPinRequested({required this.pin, required this.confirmPin});

  @override
  List<Object?> get props => [pin, confirmPin];
}

class VerifyPinRequested extends PinEvent {
  final String pin;

  const VerifyPinRequested({required this.pin});

  @override
  List<Object?> get props => [pin];
}

class ChangePinRequested extends PinEvent {
  final String oldPin;
  final String newPin;
  final String confirmNewPin;

  const ChangePinRequested({
    required this.oldPin,
    required this.newPin,
    required this.confirmNewPin,
  });

  @override
  List<Object?> get props => [oldPin, newPin, confirmNewPin];
}

/// لإعادة الحالة إلى Initial بعد عرض رسالة خطأ مثلاً (تنظيف الشاشة).
class PinStateReset extends PinEvent {
  const PinStateReset();
}
