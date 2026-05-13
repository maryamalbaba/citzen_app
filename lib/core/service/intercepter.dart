import 'package:citzenapp/core/config/EnvClass.dart';
import 'package:citzenapp/core/service/Token/tokenStorage.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;

  AuthInterceptor(this.tokenStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Accept'] = 'application/json';

    options.headers['Content-Type'] = 'application/json';

    super.onRequest(options, handler);
  }
}

//! dio client يتم استدعاءها ب

class LoggerInterceptor {

  LoggerInterceptor._();

//!مكتبة جاهزة تعمل logging لـ Dio.
  static Interceptor interceptor() {
    return PrettyDioLogger(
      requestBody: Env.debug,
      requestHeader: Env.debug,
      responseBody: Env.debug,
      error: Env.debug,
    );
  }
}
