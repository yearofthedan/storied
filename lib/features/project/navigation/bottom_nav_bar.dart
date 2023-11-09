import 'package:flutter/material.dart';
import 'package:storied/features/project/navigation/nav_menu_options.dart';

class BottomNavBar extends StatelessWidget {
  final NavMenuOptions navOptions;

  const BottomNavBar({super.key, required this.navOptions});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var navDestinations = navOptions.entries
          .map((e) => NavigationDestination(icon: Icon(e.icon), label: e.label))
          .toList();

      return ValueListenableBuilder<int>(
        valueListenable: navOptions.selected,
        builder: (BuildContext context, int value, child) {
          return NavigationBar(
            destinations: navDestinations,
            onDestinationSelected: navOptions.select,
            selectedIndex: value,
          );
        },
      );
    });
  }
}
