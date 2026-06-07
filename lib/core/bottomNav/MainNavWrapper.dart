
import 'package:citzenapp/core/bottomNav/custom_navbar.dart';
import 'package:citzenapp/core/resource/color_manager.dart';
import 'package:citzenapp/feature/homepage.dart';
import 'package:citzenapp/feature/process/presentation/type_process.dart';
import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'package:flutter/material.dart';


import '../../feature/homepage.dart';

class MainNavWrapper extends StatefulWidget {

  const MainNavWrapper({super.key});

  @override
  State<MainNavWrapper> createState() =>
      _MainNavWrapperState();
}

class _MainNavWrapperState
    extends State<MainNavWrapper> {

  int currentIndex = 0;

  final List<Widget> pages = [

    const HomePage(),

    const TransactionTypesPage(),

    const NotificationPage(),

    const ComplaintPage(),
  ];

  @override
  Widget build(BuildContext context) {

    return CustomBottomNav(

      body: pages[currentIndex],

      currentIndex: currentIndex,

      onTap: (index) {

        setState(() {

          currentIndex = index;
        });
      },
    );
  }
}

// class ProcessPage extends StatelessWidget {

//   const ProcessPage({super.key});

//   @override
//   Widget build(BuildContext context) {

//     return  Container(
//       color: Colors.red,
//     );
//   }
// }

class NotificationPage extends StatelessWidget {

  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {

    return  Container(color: Colors.amber);
  }
}

class ComplaintPage extends StatelessWidget {

  const ComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Center(
        child: Text('الشكاوي'),
      ),
    );
  }
}
// class ProcessPage extends StatelessWidget {

//   const ProcessPage({super.key});

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(

//       body: Center(
//         child: Text(
//           'المعاملات',
//         ),
//       ),
//     );
//   }
// }




// class ComplaintPage extends StatelessWidget {

//   const ComplaintPage({super.key});

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(

//       body: Center(
//         child: Text(
//           'الشكاوي',
//         ),
//       ),
//     );
//   }
// }



// class NotificationPage extends StatelessWidget {

//   const NotificationPage({super.key});

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(

//       body: Center(
//         child: Text(
//           'الإشعارات',
//         ),
//       ),
//     );
//   }
// }