/// نقاط النهاية الخاصة بميزة الـ PIN.
/// إن كان لديك ملف endpoints/url موحّد في المشروع (كالمستخدم في AuthInterceptor:
/// url.login, url.reFreshToken) فيُفضّل نقل هذه الثوابت إليه بدلاً من هذا الملف،
/// حتى تبقى جميع الروابط في مكان واحد.
class PinEndpoints {
  PinEndpoints._();

  static const String setupPin = '/api/auth/setup-pin';
  static const String verifyAppPin = '/api/auth/verify-app-pin';
  static const String changePin = '/api/auth/change-pin';
}