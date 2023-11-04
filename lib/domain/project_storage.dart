import 'package:storied/common/get_it.dart';
import 'package:storied/common/storage/app_storage.dart';
import 'package:storied/common/storage/clients/local_storage_client.dart';
import 'package:storied/domain/project.dart';

class ProjectStorage {
  Future<void> add(Project project) {
    return getIt.get<StorageClient>().createDir(project.id);
  }

  Future<void> delete(Project project) {
    return getIt.get<StorageClient>().deleteDir(project.id);
  }

  Future<List<Project>> getAll() async {
    return List<dynamic>.from(getIt.get<AppConfig>().projects)
        .map((e) => Project.fromJson(e))
        .toList();
  }
}
