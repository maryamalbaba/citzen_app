import 'package:citzenapp/feature/process/domain/usecase/usecase_typeprocess.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/faliure.dart';


import 'type_process_event.dart';
import 'type_process_state.dart';

class TypeProcessBloc
    extends Bloc<
        TypeProcessEvent,
        TypeProcessState> {

  final GetTypeProcessUseCase
      getTypeProcessUseCase;

  TypeProcessBloc(
    this.getTypeProcessUseCase,
  ) : super(
          TypeProcessInitial(),
        ) {

    on<GetTypeProcessEvent>(
      _getTypeProcess,
    );
  }

  Future<void> _getTypeProcess(
    GetTypeProcessEvent event,
    Emitter<TypeProcessState> emit,
  ) async {

    emit(
      TypeProcessLoading(),
    );

    final result =
        await getTypeProcessUseCase();

    result.fold(

      /// FAILURE
      (failure) {

        if (failure
            is EmptyDataFailure) {

          emit(
            TypeProcessEmpty(
              failure.message,
            ),
          );

        } else {

          emit(
            TypeProcessError(
              failure.message,
            ),
          );
        }
      },

      /// SUCCESS
      (data) {

        emit(
          TypeProcessLoaded(data),
        );
      },
    );
  }
}