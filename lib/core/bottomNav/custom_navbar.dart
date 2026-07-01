import 'package:citzenapp/core/navigation/%D9%90app_route.dart';
import 'package:citzenapp/feature/auth/logout/presentation/bloc/logout_bloc.dart';
import 'package:citzenapp/feature/auth/logout/presentation/bloc/logout_event.dart';
import 'package:citzenapp/feature/auth/logout/presentation/bloc/logout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:citzenapp/core/navigation/%D9%90app_route.dart';
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
        actionsIconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        backgroundColor: const Color(0xff082922),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 60,
              height: 35,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
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
      endDrawer:Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xff082922)),
              accountName: Text("اسم المستخدم", style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text("user@domain.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xff082922), size: 40),
              ),
            ),
            const Spacer(),
            
            // Logout Interaction Card Implementation Container
            BlocListener<LogoutBloc, LogoutState>(
              listener: (context, state) {
                if (state is LogoutLoading) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(
                      child: CircularProgressIndicator(color: Color(0xff082922)),
                    ),
                  );
                }
                if (state is LogoutFailure) {
                  Navigator.pop(context); // Remove progress loader
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('حدث خطأ: ${state.errorMessage}')),
                  );
                }
                if (state is LogoutSuccess) {
                  Navigator.pop(context); // Remove progress loader
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/register',
                    (route) => false,
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.red.withOpacity(0.05),
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text(
                      "تسجيل الخروج",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      context.read<LogoutBloc>().add(LogoutSubmitted());
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      extendBody: true,
      body: body,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff082922),
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.choicFlow,
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 70,
        child: PhysicalShape(
          clipper: const _StaticNotchClipper(
            fabDiameter: 56.0, // default (non-mini) FAB diameter
            notchMargin: 8.0,
          ),
          color: Colors.white,
          elevation: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTab(0),
              _buildTab(1),
              const SizedBox(width: 48), // gap for the FAB
              _buildTab(2),
              _buildTab(3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index) {
    final isActive = currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
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
        ),
      ),
    );
  }
}

/// Computes the same notch path Flutter's BottomAppBar would draw,
/// but from a fixed, locally-known FAB rect instead of querying
/// Scaffold.geometryOf() (which is unsafe outside the paint phase).
class _StaticNotchClipper extends CustomClipper<Path> {
  final double fabDiameter;
  final double notchMargin;

  const _StaticNotchClipper({
    required this.fabDiameter,
    required this.notchMargin,
  });

  @override
  Path getClip(Size size) {
    final hostRect = Rect.fromLTWH(0, 0, size.width, size.height);
    // FAB is centerDocked: horizontally centered, straddling the top edge.
    final guestRect = Rect.fromCircle(
      center: Offset(size.width / 2, 0),
      radius: fabDiameter / 2 + notchMargin,
    );
    return const CircularNotchedRectangle().getOuterPath(hostRect, guestRect);
  }

  @override
  bool shouldReclip(covariant _StaticNotchClipper oldClipper) {
    return oldClipper.fabDiameter != fabDiameter ||
        oldClipper.notchMargin != notchMargin;
  }
}
