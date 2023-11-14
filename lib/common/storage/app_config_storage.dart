import 'dart:convert';
import 'package:storied/common/storage/clients/abstract_storage_client.dart';

class AppConfigStorage {
  final AbstractStorageClient _storageClient;

  List<dynamic> projectsJson = List.of([]);

  dynamic _manifestCache;

  AppConfigStorage(this._storageClient);

  Future<AppConfigStorage> warm() async {
    _manifestCache = await getProjectManifest(force: true);
    projectsJson = await getFromManifest('projects');
    return this;
  }

  Future<String> createContentFolder(String projectId) async {
    return (await _storageClient.createDir(projectId)).path;
  }

  Future<dynamic> overwriteProjectManifest(dynamic content) async {
    await _storageClient.writeFile('projects.json', jsonEncode(content));
    return getProjectManifest();
  }

  Future<dynamic> getProjectManifest({force = false}) async {
    if (_manifestCache == null || force) {
      var result = await _storageClient.getFileData('projects.json');

      if (result != null) {
        return jsonDecode(result);
      }
      var emptyManifestData = {'projects': []};
      await _storageClient.writeFile(
          'projects.json', jsonEncode(emptyManifestData));
      return emptyManifestData;
    }

    return _manifestCache;
  }

  Future<dynamic> getFromManifest(String key) async {
    dynamic manifestJson = await getProjectManifest();

    return manifestJson[key];
  }

  Future<dynamic> setToManifest(String key, dynamic value) async {
    dynamic manifestJson = await getProjectManifest();

    manifestJson[key] = value;
    overwriteProjectManifest(manifestJson);
  }

  Future<String> getProjectRoot(projectId) async {
    return (await _storageClient.createDir(projectId)).path;
  }

  Future<dynamic> writeToProjectRoot(
      String projectId, String fileName, dynamic content) async {
    return _storageClient.writeFile(
        '$projectId/$fileName', jsonEncode(content));
  }
}
