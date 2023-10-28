import 'package:storied/config/project.dart';
import 'package:storied/features/home/story_select_option.dart';
import 'package:flutter/material.dart';

class StorySelection extends StatelessWidget {
  final List<Project> storyListing;

  final Function(Project) _navigateToStory;

  const StorySelection(this.storyListing, this._navigateToStory, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          children: storyListing.map((entry) => StorySelectOption(entry, _navigateToStory)).toList()),
    );
  }
}
