
import 'package:citzenapp/core/resource/api.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/reqestType.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/datasources/stage_config_remote_datasource.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/form_config_model.dart';

class StageConfigRemoteDataSourceImpl implements StageConfigRemoteDataSource {
  final ApiConsumer api;

  StageConfigRemoteDataSourceImpl(this.api);

  @override
  Future<FormConfigModel> getStageConfig(int id) async {
    final response = await api.request(
      path: url.stage_config + id.toString(),
      method: RequestType.get,
    );

    return FormConfigModel.fromJson(response as Map<String, dynamic>);
  }
}