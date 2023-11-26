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

    Project storedProject = await storageClient.client().add(newProject);
    _registerProjectListener(storedProject);

    projectList =
        List<Project>.from([...await _getLatestList(), storedProject]);
    getIt<AppConfig>().updateProjectList(projectList);
    notifyListeners();
    return storedProject;
  }

  _registerProjectListener(Project project) {
    project.addListener(() => _onProjectUpdate(project));
    return project;
  }

  Future<List<Project>> _getLatestList() async {
    return getIt<AppConfig>()
        .getProjectList()
        .map((e) => Project.fromJson(e))
        .toList();
  }

  _onProjectUpdate(Project project) async {
    if (project.deleted) {
      projectList = (await _getLatestList())
        ..removeWhere((element) => element.id == project.id);
      await getIt
          .get<AppConfigStorage>()
          .setToManifest('projects', projectList);
    }
    notifyListeners();
  }

  static Future<Projects> fromStorage() async {
    List<Project> projectList = getIt
        .get<AppConfig>()
        .getProjectList()
        .map((e) => Project.fromJson(e))
        .toList();

    return Projects(projectList);
  }
}
