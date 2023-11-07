import 'package:storied/common/get_it.dart';
import 'package:storied/common/storage/app_storage.dart';
import 'package:storied/common/storage/clients/local_storage_client.dart';
import 'package:storied/domain/project.dart';

class ProjectStorage {
  Future<Project> add(Project project) async {
    String result = await getIt.get<StorageClient>().createDir(project.id);
    project.path = result;

    List<Project> storedProjects = await getAll();
    storedProjects.add(project);
    await getIt.get<AppConfig>().setToManifest('projects', storedProjects);

    return project;
  }

  Future<bool> delete(Project project) async {
    await getIt.get<StorageClient>().deleteDir(project.id);

    List<Project> storedProjects = await getAll();
    storedProjects.removeWhere((entry) => entry.id == project.id);
    await getIt.get<AppConfig>().setToManifest('projects', storedProjects);

    project.deleted = true;
    return true;
  }

  Future<List<Project>> getAll() async {
    // todo set the path
    return List<dynamic>.from(getIt.get<AppConfig>().projects)
        .map((e) => Project.fromJson(e))
        .toList();
  }
}
