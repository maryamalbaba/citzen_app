import 'package:citzenapp/core/config/EnvClass.dart';
import 'package:citzenapp/core/navigation/NavigationService.dart';
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
  // ننشئ نسخة ديو منفصلة فقط لطلبات التحديث لتجنب الدخول في حلقة لا نهائية (Infinite Loop)
  final Dio _refreshDio = Dio(BaseOptions(baseUrl: Env.baseUrl));

  AuthInterceptor(this.tokenStorage);

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
    // الباكيند يرجع 404 عند انتهاء صلاحية الـ Access Token
    if (err.response?.statusCode == 404) {
      final refreshToken = await tokenStorage.getRefreshToken();

      if (refreshToken != null) {
        try {
          // محاولة تجديد التوكن
          final response = await _refreshDio.post(
            '/api/auth/refresh',
            data: {"refreshToken": refreshToken},
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            // فرضنا أن الباكيند يعود بـ accessToken و refreshToken في الـ data
            final newAccessToken = response.data['accessToken'];
            final newRefreshToken = response.data['refreshToken'] ??
                refreshToken; // إذا لم يتغير الـ refresh استعمل القديم

            // حفظ التوكنات الجديدة
            await tokenStorage.saveTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
            );

            // تعديل الطلب الأصلي الفاشل بالتوكن الجديد
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newAccessToken';

            // إعادة إرسال الطلب الأصلي بنجاح
            final cloneReq =
                await Dio(BaseOptions(baseUrl: Env.baseUrl)).fetch(options);
            return handler.resolve(cloneReq);
          }
        } catch (e) {
          // إذا فشل طلب الـ refresh (أي أن الـ Refresh Token نفسه مات)
          await tokenStorage.clearTokens();

          // توجيه المستخدم لصفحة الـ Login
          // (يفضل استخدام إما Navigator مع GlobalKey أو الـ State Management الخاص بكِ لعمل الخروج)
          _navigateToLogin();

          return handler.next(err);
        }
      }
    }

    // إذا كان الخطأ ليس 404 أو لم يكن هناك ريفريش توكن، مرر الخطأ بشكل طبيعي للـ DioConsumer
    return handler.next(err);
  }

  void _navigateToLogin() {
    
    NavigationService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (Route<dynamic> route) =>
          false, // يحذف كل الصفحات السابقة من الذاكرة لكي لا يستطيع العودة بالـ Back
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
