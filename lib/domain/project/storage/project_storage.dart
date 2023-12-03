import 'dart:convert';

import 'package:storied/clients/google_apis_provider.dart';
import 'package:storied/clients/local_storage_client.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/domain/document/document.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';

abstract class ProjectStorage {
  final StorageAdapterType type;

  get pathToProject;

  const ProjectStorage(this.type);
  Future<Document> getDocument();
  Future<Document> saveDocument(dynamic content);

  Map<String, dynamic> toJson();

  Future<bool> delete();
}

class GDriveProjectStorage extends ProjectStorage {
  final String directoryId;
  String? documentId;

  @override
  get pathToProject => 'Google Drive project: $directoryId';

  GDriveProjectStorage(this.directoryId, this.documentId)
      : super(StorageAdapterType.gdrive);

  @override
  getDocument() async {
    if (documentId == null) {
      return Document(null, this);
    }
    String rawData = await getIt<GoogleApisProvider>().getFile(documentId!);

    return Document(jsonDecode(rawData), this);
  }

  @override
  saveDocument(dynamic content) async {
    if (documentId == null) {
      documentId = await getIt<GoogleApisProvider>()
          .createFile('document.json', directoryId, jsonEncode(content));
    } else {
      await getIt<GoogleApisProvider>()
          .writeFile(documentId!, jsonEncode(content));
    }

    return Document(content, this);
  }

  @override
  Future<bool> delete() {
    return getIt<GoogleApisProvider>().deleteFile(directoryId);
  }

  static GDriveProjectStorage fromJson(json) {
    return GDriveProjectStorage(json['directoryId'], json['documentId']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': super.type.toJson(),
      'directoryId': directoryId,
      'documentId': documentId,
    };
  }
}

class LocalProjectStorage extends ProjectStorage {
  final String projectFolderPath;
  String? documentPath;

  @override
  get pathToProject => 'Local project: $projectFolderPath';

  LocalProjectStorage(this.projectFolderPath, documentPath)
      : super(StorageAdapterType.local);

  @override
  getDocument() async {
    if (documentPath == null) {
      return Document(null, this);
    }
    String? rawData =
        await getIt.get<LocalStorageClient>().getFileData(documentPath!);
    return Document(rawData == null ? null : jsonDecode(rawData), this);
  }

  @override
  saveDocument(dynamic content) async {
    documentPath ??= '$projectFolderPath/document.json';
    await getIt
        .get<LocalStorageClient>()
        .writeFile(documentPath!, jsonEncode(content));

    return Document(content, this);
  }

  @override
  Future<bool> delete() {
    return getIt.get<LocalStorageClient>().deleteDir(projectFolderPath);
  }

  static ProjectStorage fromJson(json) {
    return LocalProjectStorage(json['projectFolderPath'], json['documentPath']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': super.type.toJson(),
      'projectFolderPath': projectFolderPath,
      'documentPath': documentPath,
    };
  }
}
