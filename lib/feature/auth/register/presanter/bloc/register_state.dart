
import 'package:citzenapp/feature/auth/register/domain/entity/entity.dart';
import 'package:citzenapp/feature/auth/register/domain/entity/register_response.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {

  final RegisterResponseEntity user;

  AuthSuccess(this.user);
}

class AuthError extends AuthState {

  final String message;

  AuthError(this.message);
}