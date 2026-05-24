import 'package:bloc/bloc.dart';
import 'package:citzenapp/feature/auth/register/data/model/requestmodel.dart';

import 'package:citzenapp/feature/auth/register/domain/usecase/register_citizen_usecase.dart';

import 'package:citzenapp/feature/auth/register/domain/entity/entity.dart';
import 'package:citzenapp/feature/auth/register/presanter/bloc/register_state.dart';
import 'package:flutter/material.dart';

part 'register_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterCitizenUseCase registerCitizenUseCase;

  AuthBloc(
    this.registerCitizenUseCase,
  ) : super(AuthInitial()) {
    on<RegisterCitizenEvent>(
      _registerCitizen,
    );
  }

  Future<void> _registerCitizen(
    RegisterCitizenEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await registerCitizenUseCase(
      user: event.user,
    );

    result.fold(
      (failure) {
             debugPrint(
        'REGISTER ERROR => ${failure.message}',
      );
        emit(
          AuthError(
            failure.message,
          ),
     
        );
      },
      (user_response) {
        emit(
          AuthSuccess(user_response),
        );
      },
    );
  }
}


