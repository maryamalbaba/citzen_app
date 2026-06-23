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
  Dio? _retryDio; // يُحقن من الخارج (نفس dio الأساسي)

  
  AuthInterceptor(this.tokenStorage) {
    _initRefreshDio(); // <-- هذا السطر كان ناقصًا
  }
  // نحقن مرجع dio الأساسي بعد إنشائه، لإعادة إرسال الطلبات الفاشلة من خلاله
  void attachRetryDio(Dio dio) {
    _retryDio = dio;
  }

  void _initRefreshDio() {
    _refreshDio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) => status != null && status < 500,
      ),
    );
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
    final String? currentPath = err.requestOptions.path;

    // طباعة تشخيصية مؤقتة - احذفها بعد حل المشكلة
    print('🔴 onError triggered | path: $currentPath | status: ${err.response?.statusCode} | time: ${DateTime.now()}');

    // لا تحاول تجديد التوكن لو الطلب الفاشل هو نفسه login أو refresh
    if ((currentPath?.contains(url.login) ?? false) ||
        (currentPath?.contains(url.reFreshToken) ?? false)) {
      return handler.next(err);
    }

    if (err.response?.statusCode == 401) {
      final refreshToken = await tokenStorage.getRefreshToken();

      if (refreshToken == null) {
        await tokenStorage.clearTokens();
        _navigateToLogin();
        return handler.next(err);
      }

      try {
        final response = await _refreshDio.post(
          url.reFreshToken,
          data: {"refreshToken": refreshToken},
        );

        print('🟡 Refresh response status: ${response.statusCode} | time: ${DateTime.now()}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final newAccessToken = response.data['data']['token'];
          final newRefreshToken = response.data['data']['refreshToken'] ?? refreshToken;

          await tokenStorage.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );

          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          // مهم: استخدم dio الأساسي لإعادة الطلب، لا _refreshDio
          final cloneReq = await (_retryDio ?? _refreshDio).fetch(options);
          return handler.resolve(cloneReq);
        }

        // أي حالة غير 200/201 من الـ refresh (401, 403, إلخ) = الجلسة منتهية فعلاً
        await tokenStorage.clearTokens();
        _navigateToLogin();
        return handler.next(err);
      } catch (e) {
        print('🔴 Refresh failed with exception: $e | time: ${DateTime.now()}');
        await tokenStorage.clearTokens();
        _navigateToLogin();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  void _navigateToLogin() {
    NavigationService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (Route<dynamic> route) => false,
    );
  }
}
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
