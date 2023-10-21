import 'package:provider/provider.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/selected_story_state.dart';
import 'package:flutter/material.dart';
import 'package:storied/features/story/navigation/navigation.dart';

class StoryProjectPage extends StatelessWidget {
  final Project _project;

  const StoryProjectPage(this._project, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectedStoryState(_project),
      child: const Navigation(),
    );
  }
}
