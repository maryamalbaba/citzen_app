import 'package:citzenapp/core/config/EnvClass.dart';
import 'package:citzenapp/core/service/Token/tokenStorage.dart';

import 'package:citzenapp/core/service/intercepter.dart';
import 'package:dio/dio.dart';

class DioClient {
  late final Dio dio;

  DioClient(TokenStorage tokenStorage) {
    dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) {
          return status != null && status < 300;
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(tokenStorage),
      LoggerInterceptor.interceptor(),
    ]);
  }
}