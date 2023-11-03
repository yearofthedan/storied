import 'package:flutter/material.dart';
import 'package:storied/features/project/navigation/nav_menu_options.dart';

class NavMenu extends StatelessWidget {
  final NavMenuOptions navOptions;

  const NavMenu({super.key, required this.navOptions});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var navDestinations = navOptions.entries
          .map((e) => NavigationRailDestination(
              icon: Icon(e.icon), label: Text(e.label)))
          .toList();

      return Column(children: [
        Expanded(
          child: ValueListenableBuilder<int>(
            valueListenable: navOptions.selected,
            builder: (BuildContext context, int value, child) {
              return NavigationRail(
                labelType: NavigationRailLabelType.all,
                destinations: navDestinations,
                onDestinationSelected: navOptions.select,
                selectedIndex: value,
              );
            },
          ),
        ),
      ]);
    });
  }
}
