import 'package:citzenapp/feature/auth/otp/data/model/modelOtp.dart';

abstract class OtpEvent {}

class VerifyOtpEvent
    extends OtpEvent {

  final OtpModel otp;

  VerifyOtpEvent({
    required this.otp,
  });
}