import 'package:flutter/material.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/features/project/navigation/nav_options.dart';

class NavMenu extends StatelessWidget {
  final Widget header;
  final NavOptions navOptions;

  const NavMenu({super.key, required this.header, required this.navOptions});

  returnToHome(context) {
    getIt.popScope();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var navDestinations = getIt<NavOptions>()
          .entries
          .map((e) => NavigationRailDestination(
              icon: Icon(e.icon), label: Text(e.label)))
          .toList();

      return Column(children: [
        SizedBox(width: 200, child: header),
        Expanded(
          child: ValueListenableBuilder<int>(
            valueListenable: navOptions.selected,
            builder: (BuildContext context, int value, child) {
              return NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: navDestinations,
                onDestinationSelected: navOptions.select,
                selectedIndex: value,
              );
            },
          ),
        ),
        OutlinedButton(
          onPressed: () {
            returnToHome(context);
          },
          child: const Text('Exit'),
        )
      ]);
    });
  }
}
