import 'package:flutter/material.dart';
import 'package:storied/domain/project/project.dart';
import 'package:storied/features/project/project_screen.dart';

const routeKey = 'open-project';

navToProject(BuildContext context, Project project, {bool replace = false}) {
  var route = MaterialPageRoute(
    settings: const RouteSettings(name: routeKey),
    builder: (_) => ProjectScreen(project),
  );
  if (replace) {
    Navigator.pushReplacement(
      context,
      route,
    );
  } else {
    Navigator.push(
      context,
      route,
    );
  }
}
