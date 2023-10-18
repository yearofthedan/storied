import 'package:provider/provider.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/selected_story_state.dart';
import 'package:storied/features/story/document/document_page.dart';
import 'package:flutter/material.dart';
import 'package:storied/features/story/navigation/selected_summary.dart';

class NavEntry {
  dynamic component;
  String label;
  IconData icon;

  NavEntry(this.component, this.label, this.icon);
}

final List<NavEntry> navEntries = [
  NavEntry(const DocumentPage(), 'Document', Icons.edit),
  NavEntry(const DocumentPage(), 'Document', Icons.edit)
];

class ProjectPage extends StatelessWidget {
  final Project _project;

  const ProjectPage(this._project, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectedStoryState(_project),
      child: const StoryNavigationPage(),
    );
  }
}

class StoryNavigationPage extends StatefulWidget {
  const StoryNavigationPage({super.key});

  @override
  State<StoryNavigationPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryNavigationPage> {
  int selectedIndex = 0;

  updateIndex(int value) {
    setState(() => selectedIndex = value);
  }

  @override
  Widget build(BuildContext context) {
    Widget page = navEntries[selectedIndex].component;

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(child: NavMenu(selectedIndex, navEntries, updateIndex)),
            Expanded(child: PageLayout(child: page))
          ],
        ),
      );
    });
  }
}

class PageLayout extends StatelessWidget {
  final Widget child;

  const PageLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: child,
    );
  }
}

class NavMenu extends StatelessWidget {
  final Function(int) onNavChange;
  final int selected;
  final List<NavEntry> options;

  const NavMenu(this.selected, this.options, this.onNavChange, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(children: [
        const SizedBox(width: 200, child: SelectedSummary()),
        Expanded(
            child: NavigationRail(
          extended: constraints.maxWidth >= 600,
          destinations: options
              .map((e) => NavigationRailDestination(
                  icon: Icon(e.icon), label: Text(e.label)))
              .toList(),
          onDestinationSelected: onNavChange,
          selectedIndex: selected,
        ))
      ]);
    });
  }
}
