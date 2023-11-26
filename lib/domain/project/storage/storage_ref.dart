import 'package:storied/domain/project/storage/project_storage_adapter.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';

const localPath = '/';

class StorageReference {
  final String path;
  final StorageAdapterType type;

  const StorageReference({required this.path, required this.type});

  StorageReference.fromJson(Map<String, dynamic> json)
      : path = json['path'] ?? localPath,
        type = StorageAdapterType.fromJson(json['type']);

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'type': type.toJson(),
    };
  }

  ProjectStorageAdapter getClient() {
    return type.client();
  }
}
