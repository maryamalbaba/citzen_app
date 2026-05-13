import 'package:citzenapp/core/error/exception.dart';
import 'package:citzenapp/core/service/dioCunsumer.dart';
import 'package:dio/dio.dart';



class ErrorHandler {
  ErrorHandler._();

  static Exception handle(
    DioException e,
  ) {
    switch (e.type) {

      case DioExceptionType.connectionTimeout:

      case DioExceptionType.sendTimeout:

      case DioExceptionType.receiveTimeout:

      case DioExceptionType.connectionError:

        return ServerException(
          'الرجاء التحقق من اتصال الإنترنت',
        );

      case DioExceptionType.cancel:

        return ServerException(
          'تم إلغاء الطلب',
        );

      case DioExceptionType.badResponse:

        return _handleStatusCode(
          e.response,
        );

      case DioExceptionType.unknown:

        return ServerException(
          'حدث خطأ غير معروف',
        );

      default:

        return ServerException(
          'حدث خطأ أثناء الاتصال',
        );
    }
  }

  static Exception _handleStatusCode(
    Response? response,
  ) {
    switch (response?.statusCode) {

      case 401:

        return UnauthorizedException(
          response?.data?['message'] ??
              'غير مصرح',
        );

      case 404:

        return ServerException(
          'العنصر غير موجود',
        );

      case 500:

        return ServerException(
          'خطأ في الخادم',
        );

      default:

        return ServerException(
          response?.data?['message'] ??
              'حدث خطأ غير معروف',
        );
    }
  }
}