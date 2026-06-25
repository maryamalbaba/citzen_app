import 'package:bloc/bloc.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/submit_form_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/usecase/submit_form_usecase.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/submitBloc/bloc/submit_event.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/submitBloc/bloc/submit_state.dart';

import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitFormBloc extends Bloc<SubmitFormEvent, SubmitFormState> {
  final SubmitFormUseCase submitFormUseCase;

  SubmitFormBloc(this.submitFormUseCase) : super(const SubmitFormInitial()) {
    on<SubmitFormSubmitEvent>(_onSubmit);
  }

  Future<void> _onSubmit(
    SubmitFormSubmitEvent event,
    Emitter<SubmitFormState> emit,
  ) async {
    emit(const SubmitFormLoading());

    final result = await submitFormUseCase(
      processId: event.processId,
      entity: event.entity,
    );

    result.fold(
      (failure) => emit(SubmitFormError(failure.message)),
      (_) => emit(const SubmitFormSuccess()),
    );
  }
}