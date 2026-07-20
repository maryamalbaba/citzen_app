import 'package:citzenapp/core/config/EnvClass.dart';
import 'package:citzenapp/core/navigation/NavigationService.dart';
import 'package:citzenapp/core/resource/api.dart';
import 'package:citzenapp/core/service/Token/tokenStorage.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/get_it/injection_container.dart';
import 'package:citzenapp/core/service/notificationService/notification_device_service.dart';
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
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
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

    print(
        '🔴 onError triggered | path: $currentPath | status: ${err.response?.statusCode} | time: ${DateTime.now()}');

    // 1️⃣ استثني فقط الـ login والـ refresh الفعليين من التجديد
    if ((currentPath?.contains(url.login) ?? false) ||
        (currentPath?.contains(url.reFreshToken) ?? false)) {
      return handler.next(err);
    }

    final responseData = err.response?.data;
    final businessErrorCode =
        (responseData is Map) ? responseData['error'] as String? : null;

    // 2️⃣ قائمة الأخطاء المنطقية (بزنس) اللي السيرفر بيرجع فيها 401 بس التوكن سليم
    // تأكدي من مطابقة هذه الكلمات مع ما يرجعه السيرفر عند إدخال PIN خاطئ
    const businessLogic401Errors = <String>{
      'WRONG_PIN',
      'INVALID_PIN',
      'SECURITY_ERROR',
    };

    // لو الـ 401 بسبب PIN خاطئ وليس بسبب توكن منتهي، مرري الخطأ للـ UI مباشرة
    if (err.response?.statusCode == 401 &&
        businessErrorCode != null &&
        businessLogic401Errors.contains(businessErrorCode)) {
      return handler.next(err);
    }

    // 3️⃣ إذا وصلنا لهون والـ status == 401، يعني التوكن منتهي (حتى لو كنا بصفحة الـ PIN)
    if (err.response?.statusCode == 401) {
      final refreshToken = await tokenStorage.getRefreshToken();

      if (refreshToken == null) {
        await tokenStorage.clearTokens();
        _navigateToLogin();
        return handler.next(err);
      }

      try {
        print('🔄 Attempting to refresh token for path: $currentPath');
        final response = await _refreshDio.post(
          url.reFreshToken,
          data: {"refreshToken": refreshToken},
        );

        print(
            '🟡 Refresh response status: ${response.statusCode} | time: ${DateTime.now()}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final newAccessToken = response.data['data']['token'];
          final newRefreshToken =
              response.data['data']['refreshToken'] ?? refreshToken;

          await tokenStorage.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );

          //!  [المكان الصحيح الثاني]: مزامنة رمز الإشعارات فور تحديث التوكن
          // نستخدم sl المسجلة في GetIt لديكِ
          sl<NotificationDeviceService>().syncDeviceTokenWithServer();
          
          
          //


          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          // إعادة إرسال طلب الـ verify-app-pin بالتوكن الجديد
          final cloneReq = await (_retryDio ?? _refreshDio).fetch(options);
          return handler.resolve(cloneReq);
        }

        await tokenStorage.clearTokens();
        _navigateToLogin();
        return handler.next(err);
      } catch (e) {
        print('🔴 Refresh failed with exception: $e');
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
