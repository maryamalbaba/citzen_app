import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/form_config_entity.dart';

abstract class StageConfigState {
  const StageConfigState();
}

class StageConfigInitial extends StageConfigState {
  const StageConfigInitial();
}

class StageConfigLoading extends StageConfigState {
  const StageConfigLoading();
}

class StageConfigLoaded extends StageConfigState {
  final FormConfigEntity formConfig;

  const StageConfigLoaded(this.formConfig);
}

class StageConfigError extends StageConfigState {
  final String message;

  const StageConfigError(this.message);
}