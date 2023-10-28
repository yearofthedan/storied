import 'package:storied/config/app_storage.dart';
import 'package:storied/config/project.dart';

class AppConfig {
  final List<Project> projects;
  final AppStorage _appStorage;

  AppConfig(this._appStorage, {required this.projects});

  factory AppConfig.fromJson(AppStorage appStorage, Map<String, dynamic> json) {
    List<dynamic> pr = List<dynamic>.from(json['projects']);

    return AppConfig(appStorage, projects: List<Project>.from(pr.map((e) => Project(e['id'], e['name']))));
  }

  Future<Project> addProject(String projectName) async {
    Project newProject = Project.newWithName(projectName);

    projects.add(newProject);
    await Future.wait([_appStorage.createContentFolder(newProject.id), _appStorage.overwriteProjectManifest(toJson())]);
    return newProject;
  }

  Map<String, dynamic> toJson() => {'projects': projects.map((e) => e.toJson()).toList()};
}

class AppConfigFactory {
  static Future<AppConfig> loadConfig(AppStorage appStorage) async {
    AppConfig model = await _getAppConfig(appStorage);
    return model;
  }

  static Future<AppConfig> _getAppConfig(AppStorage appStorage) async {
    dynamic json = await appStorage.getProjectManifest() ??
        await appStorage.overwriteProjectManifest(AppConfig(appStorage, projects: []).toJson());
    return AppConfig.fromJson(appStorage, json);
  }
}
