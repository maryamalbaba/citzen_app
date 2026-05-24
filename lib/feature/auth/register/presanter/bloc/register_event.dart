part of 'register_bloc.dart';

// @immutable
// sealed class RegisterEvent {}

abstract class AuthEvent {}

class RegisterCitizenEvent
    extends AuthEvent {

  final RegisterRequestModel user;

  RegisterCitizenEvent({
    required this.user,
  });
}