import 'package:storied/config/app_storage.dart';
import 'package:storied/config/project.dart';

class ProjectStorage {
  final AppStorage _appStorage;

  ProjectStorage(this._appStorage);

  Future<void> add(Project project) {
    return _appStorage.createContentFolder(project.id);
  }

  Future<List<Project>> getAll() async {
    dynamic data = await _appStorage.getFromManifest('projects');
    return List<dynamic>.from(data).map((e) => Project.fromJson(e)).toList();
  }
}

class Projects {
  final ProjectStorage _projectStorage;
  final List<Project> projects;

  Projects(this.projects, this._projectStorage);

  Future<Project> createProject(String projectName) async {
    Project newProject = Project.newWithName(projectName);

    await _projectStorage.add(newProject);
    projects.add(newProject);

    return newProject;
  }

  static Future<Projects> fromStorage(ProjectStorage projectStorage) async {
    List<Project> storedProjects = await projectStorage.getAll();
    return Projects(storedProjects, projectStorage);
  }
}
