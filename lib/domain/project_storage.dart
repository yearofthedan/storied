import 'package:storied/common/get_it.dart';
import 'package:storied/common/storage/app_config_storage.dart';
import 'package:storied/common/storage/clients/abstract_storage_client.dart';
import 'package:storied/domain/project.dart';
import 'package:storied/domain/storage_ref.dart';

class ProjectStorage {
  Future<Project> add(String name) async {
    var newProject = Project.newWithName(name);

    StorageRef result =
        await getIt.get<AbstractStorageClient>().createDir(newProject.id);
    newProject.storage = result;

    List<Project> storedProjects = await getAll();
    storedProjects.add(newProject);
    await getIt
        .get<AppConfigStorage>()
        .setToManifest('projects', storedProjects);

    return newProject;
  }

  Future<bool> delete(Project project) async {
    await getIt.get<AbstractStorageClient>().deleteDir(project.id);

    List<Project> storedProjects = await getAll();
    storedProjects.removeWhere((entry) => entry.id == project.id);
    await getIt
        .get<AppConfigStorage>()
        .setToManifest('projects', storedProjects);

    project.deleted = true;
    return true;
  }

  Future<List<Project>> getAll() async {
    return List<dynamic>.from(getIt.get<AppConfigStorage>().projectsJson)
        .map((e) => Project.fromJson(e))
        // todo fix the missing storage refs

        .toList();
  }
}
