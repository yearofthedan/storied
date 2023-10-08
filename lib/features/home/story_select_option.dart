import 'package:bibi/features/story/story_page.dart';
import 'package:flutter/material.dart';

class StorySelectOption extends StatelessWidget {
  final String entry;

  const StorySelectOption(this.entry, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300.0,
        height: 200.0,
        child: Card(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.book),
              title: Text(entry),
              subtitle: const Text('clsick'),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryPage(entry),
                    settings: RouteSettings(
                      arguments: entry,
                    ),
                  ),
                )
              },
            )));
  }
}
