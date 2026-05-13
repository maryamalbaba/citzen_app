import 'package:citzenapp/core/error/handle_dio_error.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/dioClient.dart';

import 'package:citzenapp/core/service/reqestType.dart';
import 'package:dio/dio.dart';

class DioConsumer implements ApiConsumer {
  final Dio dio;

  DioConsumer(DioClient client) : dio = client.dio;

  @override
  Future request({
    required String path,
    required RequestType method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      Response response;

      switch (method) {
        case RequestType.get:
          response = await dio.get(
            path,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );

          break;

        case RequestType.post:
          response = await dio.post(
            path,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );

          break;

        case RequestType.put:
          response = await dio.put(
            path,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );

          break;

        case RequestType.delete:
          response = await dio.delete(
            path,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );

          break;

        case RequestType.patch:
          response = await dio.patch(
            path,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );

          break;
      }

      return response.data;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
