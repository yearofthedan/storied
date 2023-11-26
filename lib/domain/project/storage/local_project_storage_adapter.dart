import 'dart:convert';
import 'package:storied/clients/local_storage_client.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/domain/document/document.dart';
import 'package:storied/domain/project/project.dart';
import 'package:storied/domain/project/storage/project_storage_adapter.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:storied/domain/project/storage/storage_ref.dart';
import 'package:storied/features/add_project/new_project.dart';

class LocalProjectStorageAdapter implements ProjectStorageAdapter {
  @override
  Future<Project> add(NewProject newProject) async {
    StorageReference result =
        await getIt.get<LocalStorageClient>().createDir(newProject.id);
    return Project(newProject, result);
  }

  @override
  Future<bool> delete(Project project) async {
    await getIt.get<LocalStorageClient>().deleteDir(project.id);

    return true;
  }

  @override
  Future<Document> getDocument(String pathId) async {
    var rawData = await getIt
        .get<LocalStorageClient>()
        .getFileData('$pathId/document.json');
    if (rawData == null) {
      return Document(
          StorageReference(path: pathId, type: StorageAdapterType.local), null);
    }

    var data = jsonDecode(rawData);
    return Document(
        StorageReference(path: pathId, type: StorageAdapterType.local), data);
  }

  @override
  Future<Document> saveDocument(String pathId, List<dynamic> data) async {
    await getIt
        .get<LocalStorageClient>()
        .writeFile('$pathId/document.json', jsonEncode(data));

    return Document(
        StorageReference(path: pathId, type: StorageAdapterType.local), data);
  }
}
