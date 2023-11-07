import 'dart:convert';
import 'package:storied/common/storage/clients/local_storage_client.dart';

class AppConfig {
  final StorageClient _storageClient;

  List<dynamic> projects = List.of([]);

  dynamic _manifestCache;

  AppConfig(this._storageClient);

  Future<AppConfig> warm() async {
    _manifestCache = await getProjectManifest(force: true);
    projects = await getFromManifest('projects');
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
      return _storageClient.getFileData('projects.json', decoder: jsonDecode);
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

  Future<dynamic> getFromProjectRoot(projectId, String fileName) async {
    return _storageClient.getFileData('$projectId/$fileName',
        decoder: jsonDecode);
  }

  Future<dynamic> writeToProjectRoot(
      String projectId, String fileName, dynamic content) async {
    return _storageClient.writeFile(
        '$projectId/$fileName', jsonEncode(content));
  }
}
