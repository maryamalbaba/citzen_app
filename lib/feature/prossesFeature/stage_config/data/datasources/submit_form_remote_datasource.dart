import 'package:citzenapp/core/error/handle_dio_error.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/reqestType.dart';
import 'package:dio/dio.dart';

abstract class SubmitFormRemoteDataSource {
  Future<void> submitForm({
    required int processId,
    required Map<String, dynamic> body,
  });
}


class SubmitFormRemoteDataSourceImpl implements SubmitFormRemoteDataSource {
  final ApiConsumer api;

  SubmitFormRemoteDataSourceImpl(this.api);

  @override
  Future<void> submitForm({
    required int processId,
    required Map<String, dynamic> body,
  }) async {
    try {
      await api.request(
        path: '/api/transaction/submit/process/$processId',
        method: RequestType.post,
        data: body,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}