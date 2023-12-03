import 'package:flutter/material.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/config/app_config_storage.dart';
import 'package:storied/config/app_config.dart';
import 'package:storied/domain/project/project.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:storied/features/add_project/new_project.dart';

class Projects extends ChangeNotifier {
  late List<Project> projectList;

  Projects(List<Project> initialList) {
    projectList = initialList;
    initialList.forEach(_registerProjectListener);
  }

  Future<Project> createProject(
      String projectName, StorageAdapterType storageClient) async {
    var newProject = NewProject(projectName, storageClient);

    Project storedProject = await newProject.save();
    _registerProjectListener(storedProject);

    var current = await _getLatestList();

    projectList = List<Project>.from([...current, storedProject]);
    await getIt<AppConfig>().updateProjectList(projectList);
    notifyListeners();
    return storedProject;
  }

  _registerProjectListener(Project project) {
    project.addListener(() => _onProjectUpdate(project));
    return project;
  }

  Future<List<Project>> _getLatestList() async {
    List<Project> projects = await getIt<AppConfig>().getProjectList();
    return projects;
  }

  _onProjectUpdate(Project project) async {
    if (project.deleted) {
      projectList = (await _getLatestList())
        ..removeWhere((element) => element.id == project.id);
      await getIt
          .get<AppConfigStorage>()
          .setToAppManifest('projects', projectList);
    }
    notifyListeners();
  }

  static Future<Projects> fromStorage() async {
    List<Project> projectList = await getIt<AppConfig>().getProjectList();
    return Projects(projectList);
  }
}
