// login_event.dart
abstract class LoginEvent {}

class SubmitLoginEvent extends LoginEvent {
  final String userName;
  final String password;

  SubmitLoginEvent({required this.userName, required this.password});
}