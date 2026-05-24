import 'package:citzenapp/core/resource/color_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'package:citzenapp/core/resource/color_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

ItemConfig navItem({
  required String icon,
  required String title,
}) {

  return ItemConfig(

    icon: SvgPicture.asset(
      icon,
      width: 22,
      height: 22,
    ),

    title: title,

    activeForegroundColor:
        ColorManager.darkGreen,

    inactiveForegroundColor:
        Colors.grey,
  );
}

class CustomBottomNav
    extends StatelessWidget {

  final NavBarConfig navBarConfig;

  const CustomBottomNav({
    super.key,
    required this.navBarConfig,
  });

  @override
  Widget build(BuildContext context) {

    return Style6BottomNavBar(
      navBarConfig: navBarConfig,

      navBarDecoration:
          NavBarDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),
      ),
    );
  }
}