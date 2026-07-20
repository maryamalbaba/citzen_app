import 'package:citzenapp/core/bottomNav/custom_navbar.dart';
import 'package:citzenapp/core/resource/color_manager.dart';
import 'package:citzenapp/core/service/get_it/injection_container.dart';
import 'package:citzenapp/core/service/notificationService/notification_device_service.dart';
import 'package:citzenapp/feature/auth/logout/presentation/bloc/logout_bloc.dart';
import 'package:citzenapp/feature/homepage.dart';
import 'package:citzenapp/feature/notification/presentation/ui/notifications_page.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/presentation/pages/ui.dart';
import 'package:citzenapp/feature/prossesFeature/process_type/presentation/type_process.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'package:flutter/material.dart';

import '../../feature/homepage.dart';

// استدعاء ملف الـ injection container الخاص بكِ
import 'package:citzenapp/core/service/get_it/injection_container.dart' as di;

class MainNavWrapper extends StatefulWidget {
  const MainNavWrapper({super.key});

  @override
  State<MainNavWrapper> createState() => _MainNavWrapperState();
}

class _MainNavWrapperState extends State<MainNavWrapper> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    //!here
    const MyTransactionsPage(),

    const NotificationsPage(),

    const MYComplaintPage(),
  ];

  @override
  void initState() {
    
    super.initState();

    // تفعيل استماع تغير التوكن من الفايربيز
    di.sl<NotificationDeviceService>().initTokenRefreshListener();

    // مزامنة التوكن فور فتح الشاشة في الخلفية
    WidgetsBinding.instance.addPostFrameCallback((_) {
      di.sl<NotificationDeviceService>().syncDeviceTokenWithServer();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wrapping with BlocProvider solves the ProviderNotFoundException
    return BlocProvider(
      create: (context) => sl<LogoutBloc>(),
      child: CustomBottomNav(
        body: pages[currentIndex],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

class MYComplaintPage extends StatelessWidget {
  const MYComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('الشكاوي'),
      ),
    );
  }
}
