import 'package:provider/provider.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/selected_story_state.dart';
import 'package:flutter/material.dart';
import 'package:storied/features/project/navigation/navigation.dart';

class ProjectScreen extends StatelessWidget {
  final Project _project;

  const ProjectScreen(this._project, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectedStoryState(_project),
      child: const Navigation(),
    );
  }
}
