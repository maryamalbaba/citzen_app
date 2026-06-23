import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/widgets/form_config_model.dart';


abstract class StageConfigRemoteDataSource {
  Future<FormConfigModel> getStageConfig(int id);
}