import 'package:storied/config/project.dart';
import 'package:storied/features/story/story_project_page.dart';
import 'package:flutter/material.dart';

class StorySelectOption extends StatelessWidget {
  final Project project;

  const StorySelectOption(this.project, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 20.0,
        child: ListTile(
          textColor: Theme.of(context).colorScheme.onBackground,
          tileColor: Theme.of(context).colorScheme.background,
          iconColor: Theme.of(context).colorScheme.onBackground,
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
        ));
  }
}
