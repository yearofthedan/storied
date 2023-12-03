import 'package:storied/domain/project/storage/project_storage.dart';

class ProjectStorageAdapterConfig {
  final Set<StorageAdapterType> enabledStorage = {};

  enableOption(StorageAdapterType key) {
    enabledStorage.add(key);
  }

  disableOption(StorageAdapterType key) {
    enabledStorage.remove(key);
  }

  projectStorageClientFromJson(json) {
    if (StorageAdapterType.fromJson(json['type']) ==
        StorageAdapterType.gdrive) {
      return GDriveProjectStorage.fromJson(json);
    } else {
      return LocalProjectStorage.fromJson(json);
    }
  }
}

enum StorageAdapterType {
  local,
  gdrive;

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
