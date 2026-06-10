
import 'package:citzenapp/feature/auth/resendotp/data/model/resendotpmodel.dart';

abstract class ResendOtpState {}

class ResendOtpInitial extends ResendOtpState {}
class ResendOtpLoading extends ResendOtpState {}


class ResendOtpSuccess extends ResendOtpState {

  final ResendOtpResponseModel response;
  ResendOtpSuccess({required this.response});
}
class ResendOtpError extends ResendOtpState {
  final String message;
  ResendOtpError({required this.message});
}