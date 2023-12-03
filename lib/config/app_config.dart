import 'package:storied/config/app_config_storage.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/domain/project/project.dart';

class AppConfig {
  Future<List<Project>> getProjectList() async {
    var projectsJson =
        await getIt.get<AppConfigStorage>().getFromAppManifest('projects');

    List<Project> projects = [];

    for (var entry in projectsJson) {
      projects.add(Project.fromJson(entry));
    }

    return projects;
  }

  Future<void> updateProjectList(dynamic projectsList) async {
    await getIt
        .get<AppConfigStorage>()
        .setToAppManifest('projects', projectsList);
  }
}
