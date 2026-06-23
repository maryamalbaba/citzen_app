abstract class StageConfigEvent {
  const StageConfigEvent();
}

class GetStageConfigEvent extends StageConfigEvent {
  final int id;

  const GetStageConfigEvent(this.id);
}