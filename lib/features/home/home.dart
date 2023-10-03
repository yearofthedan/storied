import 'package:bibi/features/document.dart';
import 'package:bibi/features/favourites.dart';
import 'package:flutter/material.dart';

class NavEntry {
  dynamic component;
  String label;
  IconData icon;

  NavEntry(this.component, this.label, this.icon);
}

final List<NavEntry> navEntries = [
  NavEntry(const FavouritesPage(), 'Home', Icons.home),
  NavEntry(const DocumentPage(), 'Editorl', Icons.edit)
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
