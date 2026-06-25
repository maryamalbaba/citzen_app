

import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/submit_form_entity.dart';

abstract class SubmitFormEvent {
  const SubmitFormEvent();
}

class SubmitFormSubmitEvent extends SubmitFormEvent {
  final int processId;
  final SubmitFormEntity entity;

  const SubmitFormSubmitEvent({
    required this.processId,
    required this.entity,
  });
}