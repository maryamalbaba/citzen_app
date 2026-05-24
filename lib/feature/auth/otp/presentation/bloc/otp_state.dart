import 'package:citzenapp/feature/auth/register/domain/entity/entity.dart';

abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {

  final UserEntity user;

  OtpSuccess(this.user);
}

class OtpError extends OtpState {

  final String message;

  OtpError(this.message);
}