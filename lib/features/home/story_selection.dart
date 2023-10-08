import 'package:bibi/features/home/story_select_option.dart';
import 'package:flutter/material.dart';

class StorySelection extends StatelessWidget {
  final List<String> storyListing;

  const StorySelection(this.storyListing, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 4,
        children:
            storyListing.map((entry) => StorySelectOption(entry)).toList());
  }
}
