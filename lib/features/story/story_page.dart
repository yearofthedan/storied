import 'package:bibi/features/story/document/document_page.dart';
import 'package:flutter/material.dart';

class NavEntry {
  dynamic component;
  String label;
  IconData icon;

  NavEntry(this.component, this.label, this.icon);
}

final List<NavEntry> navEntries = [
  // NavEntry(const HomePage(), 'Home', Icons.home),
  NavEntry(const DocumentPage(), 'Document', Icons.edit),
  NavEntry(const DocumentPage(), 'Document', Icons.edit)
];

class StoryPage extends StatefulWidget {
  final String storyPath;

  const StoryPage(this.storyPath, {super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  // var appState = context.watch<MyAppState>();

  String? _storyPath;

  @override
  void initState() {
    _storyPath = widget.storyPath;
    super.initState();
  }

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page = navEntries[selectedIndex].component;

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
                child: NavigationRail(
              extended: constraints.maxWidth >= 600,
              destinations: navEntries
                  .map((e) => NavigationRailDestination(
                      icon: Icon(e.icon), label: Text(e.label)))
                  .toList(),
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              selectedIndex: selectedIndex,
            )),
            Expanded(
                child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ))
          ],
        ),
      );
    });
  }
}
