import 'package:get_it/get_it.dart';
import 'package:storied/config/app_storage.dart';
import 'package:storied/projects.dart';
import 'package:storied/storage/local_storage_client.dart';

GetIt getIt = GetIt.instance;

initGetIt() async {
  getIt.registerSingleton<StorageClient>(LocalStorageClient());
  // getIt.registerSingleton(AppConfig(getIt<StorageClient>()));

  getIt.registerSingletonAsync<AppConfig>(
      () => AppConfig(getIt<StorageClient>()).warm());

  getIt.registerFactoryAsync<Projects>(() => Projects.fromStorage(
      ProjectStorage(getIt<AppConfig>(), getIt<StorageClient>())));
}
