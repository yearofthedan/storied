import 'dart:io';
import 'dart:math';

import 'package:storied/storage/local_storage_client.dart';
import 'package:english_words/english_words.dart';

class Project {
  final String name;
  final String id;

  Project(this.id, this.name);

  Project.fromName(this.name) : id = name.replaceAll(' ', '_');

  Map<String, dynamic> toJson() => {'name': name, 'id': id};
}

class AppStorage {
  final LocalStorageClient _localStorageClient;

  AppStorage(this._localStorageClient);

  Future<String> createNewProjectStorage(String projectId) async {
    return (await _localStorageClient.createStorageDirectory(projectId)).path;
  }

  Future<dynamic> overwriteProjectManifest(dynamic content) async {
    return _localStorageClient.writeJsonToStorage('projects.json', content);
  }

  Future<dynamic> getProjectManifest() async {
    return _localStorageClient.getJsonFromStorage('projects.json');
  }

  Future<String> getProjectRoot(projectId) async {
    return (await _localStorageClient.createStorageDirectory(projectId)).path;
  }

  Future<dynamic> getFromProjectRoot(projectId, String fileName) async {
    String folder = await getProjectRoot(projectId);
    return _localStorageClient.getJsonFileAtPath('$folder/$fileName');
  }

  Future<File> writeToProjectRoot(
      String projectId, String fileName, dynamic content) async {
    String folder = await getProjectRoot(projectId);
    return _localStorageClient.writeJsonFileAtPath(
        '$folder/$fileName', content);
  }
}

class AppConfig {
  final List<Project> projects;
  final AppStorage _appStorage;

  AppConfig(this._appStorage, {required this.projects});

  factory AppConfig.fromJson(AppStorage appStorage, Map<String, dynamic> json) {
    List<dynamic> pr = List<dynamic>.from(json['projects']);

    return AppConfig(appStorage,
        projects:
            List<Project>.from(pr.map((e) => Project(e['id'], e['name']))));
  }

  Future<AppConfig> addProject() async {
    String projectName =
        '${nouns.elementAt(Random().nextInt(50))} ${nouns.elementAt(Random().nextInt(50))}';
    Project newProject = Project.fromName(projectName);

    projects.add(newProject);
    await Future.wait([
      _appStorage.createNewProjectStorage(newProject.id),
      _appStorage.overwriteProjectManifest(toJson())
    ]);
    return this;
  }

  Map<String, dynamic> toJson() =>
      {'projects': projects.map((e) => e.toJson()).toList()};
}

class AppConfigFactory {
  static Future<AppConfig> loadConfig(AppStorage appStorage) async {
    AppConfig model = await _getAppConfig(appStorage);
    return model;
  }

  static Future<AppConfig> _getAppConfig(AppStorage appStorage) async {
    dynamic json = await appStorage.getProjectManifest() ??
        await appStorage.overwriteProjectManifest(
            AppConfig(appStorage, projects: []).toJson());
    return AppConfig.fromJson(appStorage, json);
  }
}
