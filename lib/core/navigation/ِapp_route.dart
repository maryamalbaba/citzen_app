import 'package:citzenapp/feature/choice_flow.dart';
import 'package:citzenapp/feature/choice_flow.dart';
import 'package:citzenapp/feature/choice_flow.dart';
import 'package:citzenapp/feature/prossesFeature/process_type/presentation/type_process.dart';
import 'package:flutter/material.dart';
import 'package:citzenapp/core/bottomNav/MainNavWrapper.dart';
import 'package:citzenapp/feature/auth/login/presentation/login_ui.dart';
import 'package:citzenapp/feature/auth/otp/presentation/bloc/OtpUi.dart';
import 'package:citzenapp/feature/auth/register/presanter/bloc/page_ui.dart';

class AppRoutes {
  // أسماء المسارات كمتغيرات ثابتة لتجنب الأخطاء الإملائية (Hardcoded Strings)
  static const String register = '/register';
  static const String login = '/login';
  static const String home = '/home';
  static const String otp = '/otp';
  static const String transactionTypes= '/transactionTypes';
  static const String choicFlow= '/ChoicFlow';

  // دالة الـ Routes العادية والـ Static الشاشات التي لا تحتاج معطيات
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      register: (context) => const RegisterPage(),
      login: (context) => const LoginPage(),
      home: (context) => const MainNavWrapper(),
      transactionTypes: (context) => const TransactionTypesPage(),
      choicFlow: (context) => const ChoicFlow(),
    };
  }

  // دالة توليد المسارات الديناميكية (مثل الـ OTP التي تستقبل البيانات بأمان)
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == otp) {
      // حماية وفحص الـ arguments لضمان عدم حدوث خطأ الـ TypeError أو Null
      final args = settings.arguments as Map<String, dynamic>? ?? {};
      
      final String sessionId = args['sessionId'] ?? '';
      final String phoneNum = args['phone_num'] ?? 'المدخل';

      return MaterialPageRoute(
        builder: (context) => OtpPage(
          sessionId: sessionId,
          phone_num: phoneNum,
        ),
      );
    }
    
    // إذا لم يتطابق الاسم مع أي مسار
    return null;
  }
}