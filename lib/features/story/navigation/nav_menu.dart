import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/selected_story_state.dart';
import 'package:storied/features/story/navigation/nav_options.dart';

class NavMenu extends StatelessWidget {
  final Function(int) onNavChange;
  final int selected;
  final List<NavEntry> options;

  returnToHome(context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  const NavMenu(this.selected, this.options, this.onNavChange, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(children: [
        const SizedBox(width: 200, child: CurrentProjectHeader()),
        Expanded(
            child: NavigationRail(
          extended: constraints.maxWidth >= 600,
          destinations:
              options.map((e) => NavigationRailDestination(icon: Icon(e.icon), label: Text(e.label))).toList(),
          onDestinationSelected: onNavChange,
          selectedIndex: selected,
        )),
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

class CurrentProjectHeader extends StatelessWidget {
  const CurrentProjectHeader({super.key});

  @override
  Widget build(BuildContext context) {
    Project project = context.watch<SelectedStoryState>().project;

    return Text(project.name);
  }
}
