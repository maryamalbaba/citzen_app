import 'package:citzenapp/core/resource/api.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/reqestType.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/document_template_model.dart';

abstract class DocumentTemplateRemoteDataSource {
  Future<DocumentTemplateModel> getTemplate(int id);
}

class DocumentTemplateRemoteDataSourceImpl
    implements DocumentTemplateRemoteDataSource {
  final ApiConsumer api;

  DocumentTemplateRemoteDataSourceImpl(this.api);

  @override
  Future<DocumentTemplateModel> getTemplate(int id) async {
    final response = await api.request(
      path: url.templateDocument + id.toString(),
      method: RequestType.get,
    );
    return DocumentTemplateModel.fromJson(
        response as Map<String, dynamic>);
  }
}