import 'package:flutter/material.dart';
import 'package:storied/config/app_config.dart';

class SelectedStoryState extends ChangeNotifier {
  Project project;

  SelectedStoryState(this.project);

  void toggleStory(Project project) {
    this.project = project;
    notifyListeners();
  }
}
