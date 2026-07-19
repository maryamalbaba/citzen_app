import 'package:citzenapp/feature/prossesFeature/stage_config/domain/usecase/submit_form_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'submit_event.dart';
import 'submit_state.dart';

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

  // بدل fold نستخدم isLeft/isRight لتجنب مشكلة void
  if (result.isLeft()) {
    final failure = result.fold((f) => f, (_) => null);
    emit(SubmitFormError(failure?.message ?? 'حدث خطأ غير معروف'));
    return;
  }

  final responseData = result.fold((_) => null, (data) => data);
  final isReplay = responseData?['idempotent_replay'] as bool? ?? false;

  if (isReplay) {
    emit(const SubmitFormDuplicate());
  } else {
    emit(const SubmitFormSuccess());
  }
}
}