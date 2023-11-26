import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class NewProject {
  final String name;
  final String id;
  final StorageAdapterType storageType;

  NewProject(this.name, this.storageType) : id = uuid.v4();

  Map<String, dynamic> toJson() => {'name': name, 'id': id};
}
