import 'package:storied/config/project.dart';
import 'package:flutter/material.dart';

class ProjectListEntry extends StatelessWidget {
  final Project project;
  final Function(Project) _navigateToProject;

  const ProjectListEntry(this.project, this._navigateToProject, {super.key});

  @override
  Widget build(BuildContext context) {
    onNavigate() => _navigateToProject(project);

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
              onTap: onNavigate,
            ),
            TextButton(onPressed: onNavigate, child: const Text('view')),
          ]),
    );
  }
}
