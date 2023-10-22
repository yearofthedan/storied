import 'package:storied/config/project.dart';
import 'package:storied/features/story/story_project_page.dart';
import 'package:flutter/material.dart';

class StorySelectOption extends StatelessWidget {
  final Project project;

  const StorySelectOption(this.project, {super.key});

  _navigateToStory(context) => () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryProjectPage(project),
          ),
        );
      };

  @override
  Widget build(BuildContext context) {
    var navCallback = _navigateToStory(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
              title: Text(project.name),
              subtitle: const Text('select to see more'),
              onTap: navCallback,
            ),
            TextButton(onPressed: navCallback, child: const Text('view')),
          ]),
    );
  }
}
