import 'package:flutter/material.dart';
import 'package:storied/domain/project/project.dart';
import 'package:storied/features/add_project/add_project_screen.dart';

const routeKey = 'open-project';

navToAddProject(BuildContext context, Function(Project) onAdded) {
  Navigator.push(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: routeKey),
        fullscreenDialog: true,
        builder: (_) => AddProjectScreen(onAdded),
      ));
}
