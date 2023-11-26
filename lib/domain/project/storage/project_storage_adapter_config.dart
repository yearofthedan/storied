import 'package:storied/config/get_it.dart';
import 'package:storied/domain/project/storage/gdrive_project_storage_adapter.dart';
import 'package:storied/domain/project/storage/local_project_storage_adapter.dart';
import 'package:storied/domain/project/storage/project_storage_adapter.dart';

class ProjectStorageAdapterConfig {
  final Map<StorageAdapterType, ProjectStorageAdapter Function()>
      enabledStorage;

  ProjectStorageAdapterConfig(this.enabledStorage) {
    getIt.registerLazySingleton<LocalProjectStorageAdapter>(
        () => LocalProjectStorageAdapter());
    getIt.registerLazySingleton<GDriveProjectStorage>(
        () => GDriveProjectStorage());
  }

  ProjectStorageAdapterConfig.withLocal()
      : this({
          StorageAdapterType.local: () => getIt<LocalProjectStorageAdapter>()
        });

  enableOption(StorageAdapterType key) {
    if (key == StorageAdapterType.local) {
      enabledStorage[key] = () => getIt<LocalProjectStorageAdapter>();
    }
    if (key == StorageAdapterType.gdrive) {
      enabledStorage[key] = () => getIt<GDriveProjectStorage>();
    }
  }

  disableOption(StorageAdapterType key) {
    enabledStorage.remove(key);
  }

  ProjectStorageAdapter getClient(StorageAdapterType type) {
    if (enabledStorage.containsKey(type)) {
      return enabledStorage[type]!();
    }

    throw Exception('unknown storage type');
  }
}

enum StorageAdapterType {
  local,
  gdrive;

  ProjectStorageAdapter client() {
    return getIt<ProjectStorageAdapterConfig>().getClient(this);
  }

  static StorageAdapterType fromJson(String? value) {
    switch (value) {
      case 'local':
        return StorageAdapterType.local;
      case 'gDrive':
        return StorageAdapterType.gdrive;
      default:
        return StorageAdapterType.local;
    }
  }

  String toJson() {
    switch (this) {
      case StorageAdapterType.local:
        return 'local';
      case StorageAdapterType.gdrive:
        return 'gDrive';
    }
  }
}
