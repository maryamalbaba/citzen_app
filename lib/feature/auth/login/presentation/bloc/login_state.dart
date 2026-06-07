// login_state.dart
import 'package:citzenapp/feature/auth/login/data/models/LoginResponseModel.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final LoginResponseModel responseModel;
  LoginSuccess(this.responseModel);
}
class LoginFailure extends LoginState {
  final String errorMessage;
  LoginFailure(this.errorMessage);
}