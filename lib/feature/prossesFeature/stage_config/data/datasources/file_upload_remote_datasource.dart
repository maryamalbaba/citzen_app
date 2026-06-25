import 'package:citzenapp/core/error/handle_dio_error.dart';
import 'package:citzenapp/core/resource/api.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/data/models/widgets/uploaded_file_model.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/uploaded_file_entity.dart';
import 'package:dio/dio.dart';

abstract class FileUploadRemoteDataSource {
  Future<UploadedFileModel> uploadFile({
    required String filePath,
    required String fileName,
    required int typeDocId,
    required String key,
  });
}

class FileUploadRemoteDataSourceImpl implements FileUploadRemoteDataSource {
  final Dio dio;

  FileUploadRemoteDataSourceImpl(this.dio);

  @override
  Future<UploadedFileModel> uploadFile({
    required String filePath,
    required String fileName,
    required int typeDocId,
    required String key,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
        'type_doc_id': typeDocId,
        'key': key,
      });

      final response = await dio.post(
        url.uploadFile,
        data: formData,
        options: Options(
          // مهم: نبلغ Dio أن هذا multipart
          contentType: 'multipart/form-data',
        ),
      );

      return UploadedFileModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
