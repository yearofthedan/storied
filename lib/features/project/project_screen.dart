import 'package:flutter/material.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/project/navigation/navigation.dart';

class ProjectScreen extends StatelessWidget {
  final Project _project;

  const ProjectScreen(this._project, {super.key});

  @override
  Widget build(BuildContext context) {
    return Navigation(_project);
  }
}
