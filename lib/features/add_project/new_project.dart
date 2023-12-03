import 'package:storied/clients/google_apis_provider.dart';
import 'package:storied/clients/local_storage_client.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/domain/project/project.dart';
import 'package:storied/domain/project/storage/project_storage.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class NewProject {
  final String name;
  final String id;
  final StorageAdapterType storageType;

  NewProject(this.name, this.storageType) : id = uuid.v4();

  Map<String, dynamic> toJson() => {'name': name, 'id': id};

  save() async {
    if (storageType == StorageAdapterType.gdrive) {
      var directoryId =
          await getIt<GoogleApisProvider>().createDir('storied_project_$name');
      return Project(id, name, GDriveProjectStorage(directoryId, null));
    } else {
      String path = await getIt.get<LocalStorageClient>().createDir(id);
      return Project(id, name, LocalProjectStorage(path, null));
    }
  }
}
