import 'package:flutter/material.dart';
import 'package:storied/features/project/document/document_page.dart';
import 'package:storied/features/project/navigation/nav_menu.dart';
import 'package:storied/features/project/navigation/nav_options.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selectedIndex = 0;

  updateIndex(int value) {
    setState(() => selectedIndex = value);
  }

  @override
  Widget build(BuildContext context) {
    final List<NavEntry> navEntries = [
      NavEntry(const DocumentPage(), 'Document', Icons.edit, updateIndex),
      NavEntry(const DocumentPage(), 'Document', Icons.edit, updateIndex),
      // NavEntry(Container(), 'Exit', Icons.arrow_back, returnToHome),
    ];

    Widget page = navEntries[selectedIndex].component;

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(child: NavMenu(selectedIndex, navEntries, updateIndex)),
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
