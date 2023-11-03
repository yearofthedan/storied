import 'package:storied/domain/project.dart';
import 'package:flutter/material.dart';
import 'package:storied/features/home/terms.dart';

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
            Expanded(
              child: ListTile(
                title: Text(project.name),
                subtitle: const Text(selectStoryActionLabel),
                onTap: onNavigate,
              ),
            ),
          ]),
    );
  }
}
