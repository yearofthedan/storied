import 'package:flutter/material.dart';
import 'package:storied/features/add_project/add_project_screen.dart';
import 'package:storied/features/project/routes.dart';

const routeKey = 'open-project';

navToAddProject(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: routeKey),
        fullscreenDialog: true,
        builder: (_) => AddProjectScreen(
            (project) => navToProject(context, project, replace: true)),
      ));
}
