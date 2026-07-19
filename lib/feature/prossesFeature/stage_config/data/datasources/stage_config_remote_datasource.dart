import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/form_config_model.dart';


abstract class StageConfigRemoteDataSource {
  Future<FormConfigModel> getStageConfig(int id);
}