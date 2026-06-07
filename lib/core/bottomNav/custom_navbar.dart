import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNav extends StatelessWidget {
  final Widget body;

  final int currentIndex;

  final Function(int) onTap;

  CustomBottomNav({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTap,
  });

  final List<String> icons = [
    'assets/icons/Home.svg',
    'assets/icons/Category.svg',
    'assets/icons/Notification.svg',
    'assets/icons/file.svg',
  ];

  final List<String> titles = [
    'الرئيسية',
    'المعاملات',
    'الإشعارات',
    'الشكاوي',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: const Color(0xff082922),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// اللوغو
            Image.asset(
              'assets/images/logo.png',
              width: 60,
              height: 35,
              fit: BoxFit.contain,
            ),

            const SizedBox(width: 8),

            /// النصوص
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "الجمهورية العربية السورية",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                  Text(
                    "مديرية التربية والتعليم بريف دمشق",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      extendBody: false,
      body: body,
      floatingActionButton: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xff082922),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: 
         AnimatedBottomNavigationBar.builder(
          itemCount: icons.length,
          activeIndex: currentIndex,
          gapLocation: GapLocation.center,
          // notchSmoothness: NotchSmoothness.softEdge,
          // leftCornerRadius: 20,
          // rightCornerRadius: 20,
          height: 70,
          backgroundColor: Colors.white,
          tabBuilder: (index, isActive) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  icons[index],
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    isActive ? const Color(0xff082922) : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  titles[index],
                  style: TextStyle(
                    fontSize: 11,
                    color: isActive ? const Color(0xff082922) : Colors.grey,
                  ),
                ),
              ],
            );
          },
          onTap: onTap,
        ),
      );
    
  }
}
