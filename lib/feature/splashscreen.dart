import 'package:citzenapp/core/service/Token/tokenStorage.dart';
import 'package:citzenapp/core/service/get_it/injection_container.dart'
    as di; // للتأكد من مسار الـ sl
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // استدعاء دالة الفحص فور تشغيل الصفحة
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // انتظر ثانيتين لعرض اللوجو أو الأنيميشن
    await Future.delayed(const Duration(seconds: 2));

    // جلب نسخة الـ TokenStorage المسجلة في الـ GetIt (sl)
    final tokenStorage = di.sl<TokenStorage>();
    final accessToken = await tokenStorage.getAccessToken();

    if (!mounted) return;
    // Navigator.pushReplacementNamed(context, '/login');
//!Vip this is correct which is comment
    if (accessToken != null) {
      // إذا يوجد توكن، نتوجه مباشرة للرئيسية ونحذف الـ Splash من
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // إذا لا يوجد، نتوجه لصفحة التسجيل/الدخول
      Navigator.pushReplacementNamed(context, '/register');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/images/logo.png'),
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
