import 'package:citzenapp/core/config/EnvClass.dart';
import 'package:citzenapp/core/service/Token/tokenStorage.dart';

import 'package:citzenapp/core/service/intercepter.dart';
import 'package:dio/dio.dart';

class DioClient {
  late final Dio dio;
  late final AuthInterceptor _authInterceptor;

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

    _authInterceptor = AuthInterceptor(tokenStorage);
    _authInterceptor.attachRetryDio(dio); // الربط المهم

    dio.interceptors.addAll([
      _authInterceptor,
      LoggerInterceptor.interceptor(),
    ]);
  }
}