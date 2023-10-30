import 'package:storied/config/project.dart';
import 'package:storied/features/home/project_list_entry.dart';
import 'package:flutter/material.dart';

class ProjectList extends StatelessWidget {
  final List<Project> projectList;

  final Function(Project) _navigateToProject;

  const ProjectList(this.projectList, this._navigateToProject, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          children: projectList
              .map((entry) => ProjectListEntry(entry, _navigateToProject))
              .toList()),
    );
  }
}
