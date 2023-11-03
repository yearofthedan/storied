import 'package:flutter/material.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/domain/project.dart';
import 'package:storied/domain/project_storage.dart';

class Projects extends ChangeNotifier {
  final List<Project> projectList;

  ValueNotifier<Project?> active = ValueNotifier(null);

  Projects(List<Project> initialList) : projectList = initialList;

  Future<Project> createProject(String projectName) async {
    Project newProject = Project.newWithName(projectName);
    await getIt<ProjectStorage>().add(newProject);

    projectList.add(newProject);
    notifyListeners();
    return newProject;
  }

  static Future<Projects> fromStorage() async {
    List<Project> storedProjects = await getIt<ProjectStorage>().getAll();
    var projects = Projects(storedProjects);
    return projects;
  }

  void setActive(Project project) {
    active.value = project;
  }
}
