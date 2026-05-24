import 'package:citzenapp/core/bottomNav/MainNavWrapper.dart';
import 'package:citzenapp/feature/auth/register/presanter/bloc/page_ui.dart';
import 'package:citzenapp/feature/process/presentation/type_process.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env.dev");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: MainNavWrapper(),
          );
        },
              child: RegisterPage(),

        );
  }
}
