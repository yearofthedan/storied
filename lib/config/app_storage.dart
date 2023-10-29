import 'dart:convert';
import 'package:storied/storage/local_storage_client.dart';

class AppStorage {
  final LocalStorageClient _localStorageClient;

  dynamic _manifestCache;

  AppStorage(this._localStorageClient);

  warm() async {
    _manifestCache = await getProjectManifest(force: true);
  }

  Future<String> createContentFolder(String projectId) async {
    return (await _localStorageClient.createDir(projectId)).path;
  }

  Future<dynamic> overwriteProjectManifest(dynamic content) async {
    await _localStorageClient.writeFile('projects.json', jsonEncode(content));
    return getProjectManifest();
  }

  Future<dynamic> getProjectManifest({force = false}) async {
    if (_manifestCache == null || force) {
      return _localStorageClient.getFile('projects.json', decoder: jsonDecode);
    }

    return _manifestCache;
  }

  Future<dynamic> getFromManifest(String key) async {
    dynamic manifestJson = await getProjectManifest();

    return manifestJson['projects'];
  }

  Future<String> getProjectRoot(projectId) async {
    return (await _localStorageClient.createDir(projectId)).path;
  }

  Future<dynamic> getFromProjectRoot(projectId, String fileName) async {
    return _localStorageClient.getFile('$projectId/$fileName',
        decoder: jsonDecode);
  }

  Future<dynamic> writeToProjectRoot(
      String projectId, String fileName, dynamic content) async {
    return _localStorageClient.writeFile(
        '$projectId/$fileName', jsonEncode(content));
  }
}
