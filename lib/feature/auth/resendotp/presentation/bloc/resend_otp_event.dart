abstract class ResendOtpEvent {}

class TriggerResendOtpEvent extends ResendOtpEvent {
  final String oldSessionId;
  TriggerResendOtpEvent({required this.oldSessionId});
}