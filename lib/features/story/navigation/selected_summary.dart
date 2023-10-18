import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/selected_story_state.dart';

class SelectedSummary extends StatelessWidget {
  const SelectedSummary({super.key});

  @override
  Widget build(BuildContext context) {
    Project project = context.watch<SelectedStoryState>().project;

    return Text(project.name);
  }
}
