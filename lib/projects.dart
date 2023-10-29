import 'package:storied/config/app_storage.dart';
import 'package:storied/config/project.dart';
import 'package:storied/storage/local_storage_client.dart';

class ProjectStorage {
  final AppConfig _appConfig;
  final StorageClient _storageClient;

  ProjectStorage(this._appConfig, this._storageClient);

  Future<void> add(Project project) {
    return _storageClient.createDir(project.id);
  }

  Future<List<Project>> getAll() async {
    return List<dynamic>.from(_appConfig.projects)
        .map((e) => Project.fromJson(e))
        .toList();
  }
}

class Projects {
  final ProjectStorage _projectStorage;
  final List<Project> projectList;

  Projects(this.projectList, this._projectStorage);

  Future<Project> createProject(String projectName) async {
    Project newProject = Project.newWithName(projectName);

    await _projectStorage.add(newProject);
    projectList.add(newProject);

    return newProject;
  }

  static Future<Projects> fromStorage(ProjectStorage projectStorage) async {
    List<Project> storedProjects = await projectStorage.getAll();
    return Projects(storedProjects, projectStorage);
  }
}
