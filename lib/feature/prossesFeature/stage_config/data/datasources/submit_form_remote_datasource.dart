import 'package:citzenapp/core/error/handle_dio_error.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/reqestType.dart';
import 'package:dio/dio.dart';

abstract class SubmitFormRemoteDataSource {
  Future<Map<String, dynamic>?> submitForm({
    required int processId,
    required Map<String, dynamic> body,
  });
}

class SubmitFormRemoteDataSourceImpl implements SubmitFormRemoteDataSource {
  final ApiConsumer api;

  SubmitFormRemoteDataSourceImpl(this.api);

  @override
  Future<Map<String, dynamic>?> submitForm({
    required int processId,
    required Map<String, dynamic> body,
  }) async {
    final response = await api.request(
      path: '/api/transaction/submit/process/$processId',
      method: RequestType.post,
      data: body,
    );
    return response as Map<String, dynamic>?;
  }
}