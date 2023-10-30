import 'package:get_it/get_it.dart';
import 'package:storied/config/app_storage.dart';
import 'package:storied/projects.dart';
import 'package:storied/storage/local_storage_client.dart';

GetIt getIt = GetIt.instance;

initGetIt() async {
  getIt.registerSingleton<StorageClient>(LocalStorageClient());
  getIt.registerSingletonAsync<AppConfig>(
      () => AppConfig(getIt<StorageClient>()).warm());

  getIt.registerSingletonWithDependencies<ProjectStorage>(
      () => ProjectStorage(),
      dependsOn: [AppConfig]);

  getIt.registerSingletonAsync(() => Projects.fromStorage(),
      dependsOn: [ProjectStorage]);
}
