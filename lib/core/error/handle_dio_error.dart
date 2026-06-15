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
static Exception _handleStatusCode(Response? response) {
    // استخراج رسالة الخطأ القادمة من الباكيند إن وجدت داخل الـ JSON
    final serverMessage = response?.data?['message'] ?? response?.data?['error'];

    switch (response?.statusCode) {
      case 401:
        // هنا نقرأ الرسالة القادمة من الباكيند ديناميكياً (مثل: كلمة المرور قصيرة، الحساب غير موجود.. إلخ)
        return UnauthorizedException(
          serverMessage ?? 'اسم المستخدم أو كلمة المرور غير صحيحة',
        );

      case 403:
        return ServerException(
          serverMessage ?? 'عذراً، لا تملك الصلاحية للقيام بهذا الإجراء',
        );

      case 404:
        return ServerException(
          serverMessage ?? 'المورد أو العنصر غير موجود',
        );

      case 422: // البيانات مقبولة شكلاً ومرفوضة منطقياً
        return ServerException(
          serverMessage ?? 'البيانات المرسلة غير صالحة',
        );

      case 423:
        return ServerException(
          serverMessage ?? 'تم قفل الحساب مؤقتاً، يرجى المحاولة لاحقاً',
        );

      case 500:
        return ServerException('خطأ داخلي في الخادم، يرجى المحاولة لاحقاً');

      default:
        return ServerException(
          serverMessage ?? 'حدث خطأ غير معروف، يرجى المحاولة لاحقاً',
        );
    }
  }
}
