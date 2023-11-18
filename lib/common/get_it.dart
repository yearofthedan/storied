import 'package:get_it/get_it.dart';
import 'package:storied/clients/google_apis_provider.dart';
import 'package:storied/common/exceptions.dart';
import 'package:storied/common/storage/app_config_storage.dart';
import 'package:storied/common/storage/clients/abstract_storage_client.dart';
import 'package:storied/domain/project_storage.dart';
import 'package:storied/domain/projects.dart';
import 'package:storied/common/storage/clients/local_storage_client.dart';

GetIt getIt = GetIt.instance;

initGetIt() async {
  getIt.registerSingleton<Observability>(Observability());
  getIt.registerSingleton<LocalStorageClient>(LocalStorageClient());
  getIt.registerSingleton<AbstractStorageClient>(LocalStorageClient());
  getIt.registerSingletonAsync<AppConfigStorage>(
      () => AppConfigStorage(getIt<LocalStorageClient>()).warm());

  getIt.registerSingletonWithDependencies<ProjectStorage>(
      () => ProjectStorage(),
      dependsOn: [AppConfigStorage]);

  getIt.registerSingletonAsync(() => Projects.fromStorage(),
      dependsOn: [ProjectStorage]);

  getIt.registerSingleton<GoogleApisProvider>(GoogleApisProvider.driveScoped());
}
