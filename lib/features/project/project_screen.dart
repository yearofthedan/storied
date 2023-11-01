import 'package:flutter/material.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/project/navigation/navigation.dart';

class ProjectScreen extends StatelessWidget {
  final Project _project;

  ProjectScreen(this._project, {super.key}) {
    getIt.pushNewScope(
        init: (c) => c.registerSingleton<Project>(_project),
        scopeName: _project.id);
  }

  @override
  Widget build(BuildContext context) {
    return Navigation(_project);
  }
}
