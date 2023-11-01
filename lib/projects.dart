import 'package:flutter/material.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/config/app_storage.dart';
import 'package:storied/config/project.dart';
import 'package:storied/storage/local_storage_client.dart';

class ProjectStorage {
  final AppConfig _appConfig;
  final StorageClient _storageClient;

  ProjectStorage()
      : _appConfig = getIt.get<AppConfig>(),
        _storageClient = getIt.get<StorageClient>();

  Future<void> add(Project project) {
    return _storageClient.createDir(project.id);
  }

  Future<List<Project>> getAll() async {
    return List<dynamic>.from(_appConfig.projects)
        .map((e) => Project.fromJson(e))
        .toList();
  }
}

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
