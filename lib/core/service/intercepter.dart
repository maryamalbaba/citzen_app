import 'package:citzenapp/core/config/EnvClass.dart';
import 'package:citzenapp/core/navigation/NavigationService.dart';
import 'package:citzenapp/core/resource/api.dart';
import 'package:citzenapp/core/service/Token/tokenStorage.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// auth_interceptor.dart
import 'package:citzenapp/core/config/EnvClass.dart';
import 'package:citzenapp/core/service/Token/tokenStorage.dart';
import 'package:dio/dio.dart';
class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  late final Dio _refreshDio;

  AuthInterceptor(this.tokenStorage) {
    // نجهز نسخة الـ refresh مع نفس إعدادات الوقت والـ validateStatus لضمان الحماية
    _refreshDio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) {
          // نجعلها تقبل الـ 401 هنا لنستطيع قراءته ومعالجته يدوياً دون الانهيار
          return status != null && status < 500;
        },
      ),
    );
    // نربط معها الـ Logger لكي تري بوضوح في الـ Console عملية تجديد التوكن
    _refreshDio.interceptors.add(LoggerInterceptor.interceptor());
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokenStorage.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    return handler.next(options);
  }
@override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 1. استخراج مسار الطلب الحالي الذي فشل
    final String? currentPath = err.requestOptions.path;

    // 2. إذا كان الخطأ 401 ولكن الطلب القادم هو من الـ Login API، مرري الخطأ فوراً للـ ErrorHandler
    if (currentPath?.contains(url.login) ?? false) {
      return handler.next(err); 
    }

    // 3. باقي الـ APIs الأخرى في المشروع تعامل بشكل طبيعي مع الـ Refresh Token
    if (err.response?.statusCode == 401) {
      final refreshToken = await tokenStorage.getRefreshToken();

      if (refreshToken != null) {
        try {
          final response = await _refreshDio.post(
            url.reFreshToken,
            data: {"refreshToken": refreshToken},
          );

          if (response.statusCode == 401) {
            await tokenStorage.clearTokens();
            _navigateToLogin();
            return handler.next(err);
          }

          if (response.statusCode == 200 || response.statusCode == 201) {
            final newAccessToken = response.data['accessToken'];
            final newRefreshToken = response.data['refreshToken'] ?? refreshToken;

            await tokenStorage.saveTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
            );

            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newAccessToken';

            final cloneReq = await _refreshDio.fetch(options);
            return handler.resolve(cloneReq);
          }
        } catch (e) {
          await tokenStorage.clearTokens();
          _navigateToLogin();
          return handler.next(err);
        }
      }
    }

    // إذا كان الخطأ ليس 401 لأي API آخر، مرريه للـ ErrorHandler
    return handler.next(err);
  }

  void _navigateToLogin() {
    NavigationService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (Route<dynamic> route) => false,
    );
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
