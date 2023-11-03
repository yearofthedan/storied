import 'package:storied/common/get_it.dart';
import 'package:storied/common/storage/app_storage.dart';
import 'package:storied/common/storage/clients/local_storage_client.dart';
import 'package:storied/domain/project.dart';

class ProjectStorage {
  final AppConfig _appConfig;
  final StorageClient _storageClient;

  ProjectStorage()
      : _appConfig = getIt.get<AppConfig>(),
        _storageClient = getIt.get<StorageClient>();

  Future<void> add(Project project) {
    return _storageClient.createDir(project.id);
  }

  Future<void> delete(Project project) {
    return Future.value();
  }

  Future<List<Project>> getAll() async {
    return List<dynamic>.from(_appConfig.projects)
        .map((e) => Project.fromJson(e))
        .toList();
  }
}
