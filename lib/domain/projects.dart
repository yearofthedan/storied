import 'package:flutter/material.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/domain/project.dart';
import 'package:storied/domain/project_storage.dart';

class Projects extends ChangeNotifier {
  late List<Project> projectList;

  Projects(List<Project> initialList) {
    projectList = initialList;
    initialList.forEach(_registerProjectListener);
  }

  _onUpdate(Project project) {
    if (project.deleted) {
      var updatedList = List<Project>.from(projectList);
      updatedList.removeWhere((element) => element.id == project.id);
      projectList = updatedList;
    }
    notifyListeners();
  }

  Future<Project> createProject(String projectName) async {
    Project newProject = await getIt<ProjectStorage>().add(projectName);
    _registerProjectListener(newProject);
    projectList = List<Project>.from([...projectList, newProject]);
    notifyListeners();
    return newProject;
  }

  _registerProjectListener(Project project) {
    project.addListener(() => _onUpdate(project));
    return project;
  }

  static Future<Projects> fromStorage() async {
    List<Project> storedProjects = await getIt<ProjectStorage>().getAll();
    var projects = Projects(storedProjects);
    return projects;
  }
}
