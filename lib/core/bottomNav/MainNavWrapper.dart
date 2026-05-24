
import 'package:citzenapp/core/bottomNav/custom_navbar.dart';
import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';


class MainNavWrapper
    extends StatelessWidget {

  const MainNavWrapper({super.key});

  @override
  Widget build(BuildContext context) {

    return PersistentTabView(

      tabs: [

        /// HOME
        PersistentTabConfig(
          screen: const HomePage(),

          item: navItem(
            icon:
                'assets/icons/Home.svg',

            title: 'الرئيسية',
          ),
        ),

        /// PROCESS
        PersistentTabConfig(
          screen: const ProcessPage(),

          item: navItem(
            icon:
                'assets/icons/Category.svg',

            title: 'المعاملات',
          ),
        ),

        /// NOTIFICATION
        PersistentTabConfig(
          screen:
              const NotificationPage(),

          item: navItem(
            icon:
                'assets/icons/Notification.svg',

            title: 'الإشعارات',
          ),
        ),

        /// COMPLAINT
        PersistentTabConfig(
          screen:
              const ComplaintPage(),

          item: navItem(
            icon:
                'assets/icons/file.svg',

            title: 'شكاوي',
          ),
        ),
      ],

      navBarBuilder:
          (navBarConfig) =>
              CustomBottomNav(
        navBarConfig: navBarConfig,
      ),
    );
  }
}




class HomePage extends StatelessWidget {

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child: Text(
          'الرئيسية',
        ),
      ),
    );
  }
}



class ProcessPage extends StatelessWidget {

  const ProcessPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child: Text(
          'المعاملات',
        ),
      ),
    );
  }
}




class ComplaintPage extends StatelessWidget {

  const ComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child: Text(
          'الشكاوي',
        ),
      ),
    );
  }
}



class NotificationPage extends StatelessWidget {

  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child: Text(
          'الإشعارات',
        ),
      ),
    );
  }
}