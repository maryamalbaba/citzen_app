part of 'pin_bloc.dart';

abstract class PinState extends Equatable {
  const PinState();

  @override
  List<Object?> get props => [];
}

class PinInitial extends PinState {
  const PinInitial();
}

// ------- فحص الحالة عند بدء التطبيق -------
class PinStatusChecking extends PinState {
  const PinStatusChecking();
}

/// [hasPinCreated] == true  -> يجب عرض شاشة "التحقق من PIN" (قفل التطبيق)
/// [hasPinCreated] == false -> لا يوجد PIN بعد، لا حاجة لعرض شاشة التحقق إطلاقاً
class PinStatusChecked extends PinState {
  final bool hasPinCreated;

  const PinStatusChecked(this.hasPinCreated);

  @override
  List<Object?> get props => [hasPinCreated];
}

// ------- إنشاء PIN لأول مرة -------
class PinSetupLoading extends PinState {
  const PinSetupLoading();
}

class PinSetupSuccess extends PinState {
  final String message;

  const PinSetupSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PinSetupFailure extends PinState {
  final String message;

  const PinSetupFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// ------- التحقق من PIN (فتح قفل التطبيق) -------
class PinVerifyLoading extends PinState {
  const PinVerifyLoading();
}

class PinVerifySuccess extends PinState {
  final String message;

  const PinVerifySuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PinVerifyFailure extends PinState {
  final String message;

  const PinVerifyFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// ------- تغيير PIN -------
class PinChangeLoading extends PinState {
  const PinChangeLoading();
}

class PinChangeSuccess extends PinState {
  final String message;

  const PinChangeSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PinChangeFailure extends PinState {
  final String message;

  const PinChangeFailure(this.message);

  @override
  List<Object?> get props => [message];
}
