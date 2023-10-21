import 'package:storied/config/project.dart';
import 'package:storied/features/story/story_project_page.dart';
import 'package:flutter/material.dart';

class StorySelectOption extends StatelessWidget {
  final Project project;

  const StorySelectOption(this.project, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300.0,
        height: 200.0,
        child: Card(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.book),
              title: Text(project.name),
              subtitle: const Text('click'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryProjectPage(project),
                  ),
                );
              },
            )));
  }
}
