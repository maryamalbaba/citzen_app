import 'package:citzenapp/core/bottomNav/MainNavWrapper.dart';
import 'package:citzenapp/core/game/ConnectivityGate.dart';
import 'package:citzenapp/core/navigation/%D9%90app_route.dart';
import 'package:citzenapp/core/navigation/NavigationService.dart';
import 'package:citzenapp/feature/auth/login/presentation/login_ui.dart';
import 'package:citzenapp/feature/auth/otp/presentation/bloc/OtpUi.dart';
import 'package:citzenapp/feature/auth/register/presanter/bloc/page_ui.dart';
import 'package:citzenapp/feature/prossesFeature/process_type/presentation/type_process.dart';
import 'package:citzenapp/feature/splashscreen.dart';
import 'package:citzenapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:citzenapp/core/service/get_it/injection_container.dart'
    as di; // Import your injection file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env.dev");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize  service locator!
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          navigatorKey: NavigationService.navigatorKey, // نربط المفتاح هنا
          locale: const Locale('ar'),
          supportedLocales: const [
            Locale('ar'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          routes:AppRoutes.getRoutes(),
     
          onGenerateRoute: AppRoutes.onGenerateRoute,
          // 🌟 هنا نقوم بتغليف التطبيق بالكامل ببوابة فحص الإنترنت 🌟
          builder: (context, widget) {
            return ConnectivityGate(child: widget!);
          },
        );
      },
    );
  }
}
