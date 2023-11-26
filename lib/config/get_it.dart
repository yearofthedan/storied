import 'package:get_it/get_it.dart';
import 'package:storied/clients/google_apis_provider.dart';
import 'package:storied/clients/local_storage_client.dart';
import 'package:storied/config/app_config_storage.dart';
import 'package:storied/common/exceptions.dart';
import 'package:storied/config/app_config.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:storied/domain/projects.dart';

GetIt getIt = GetIt.instance;

initGetIt() {
  getIt.registerSingleton<Observability>(Observability());

  getIt.registerSingleton<LocalStorageClient>(LocalStorageClient());
  getIt.registerSingleton<ProjectStorageAdapterConfig>(
      ProjectStorageAdapterConfig.withLocal());

  getIt.registerSingletonAsync<AppConfigStorage>(
      () => AppConfigStorage().warm());

  getIt.registerSingletonWithDependencies<AppConfig>(() => AppConfig(),
      dependsOn: [AppConfigStorage]);

  getIt.registerSingletonAsync(() => Projects.fromStorage(),
      dependsOn: [AppConfig]);

  getIt.registerLazySingleton<GoogleApisProvider>(
      () => GoogleApisProvider.driveScoped());
}
