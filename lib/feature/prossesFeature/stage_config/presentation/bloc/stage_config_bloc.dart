import 'package:citzenapp/feature/prossesFeature/stage_config/domain/usecase/get_stage_config_usecase.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/stage_config_event.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/stage_config_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StageConfigBloc extends Bloc<StageConfigEvent, StageConfigState> {
  final GetStageConfigUseCase getStageConfigUseCase;

  StageConfigBloc(this.getStageConfigUseCase) : super(const StageConfigInitial()) {
    on<GetStageConfigEvent>(_onGetStageConfig);
  }

  Future<void> _onGetStageConfig(
    GetStageConfigEvent event,
    Emitter<StageConfigState> emit,
  ) async {
    emit(const StageConfigLoading());

    final result = await getStageConfigUseCase(event.id);

    result.fold(
      (failure) => emit(StageConfigError(failure.message)),
      (formConfig) => emit(StageConfigLoaded(formConfig)),
    );
  }
}