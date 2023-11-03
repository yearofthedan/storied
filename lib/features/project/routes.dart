import 'package:flutter/material.dart';
import 'package:storied/domain/project.dart';
import 'package:storied/features/project/project_screen.dart';

const routeKey = 'open-project';

navToProject(BuildContext context, Project project) {
  Navigator.push(
    context,
    MaterialPageRoute(
      settings: const RouteSettings(name: routeKey),
      builder: (_) => ProjectScreen(project),
    ),
  );
}
