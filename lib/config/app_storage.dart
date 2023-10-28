import 'dart:io';

import 'package:storied/storage/local_storage_client.dart';

class AppStorage {
  final LocalStorageClient _localStorageClient;

  dynamic _manifestCache;

  AppStorage(this._localStorageClient);

  warm() async {
    _manifestCache = await getProjectManifest(force: true);
  }

  Future<String> createContentFolder(String projectId) async {
    return (await _localStorageClient.createStorageDirectory(projectId)).path;
  }

  Future<dynamic> overwriteProjectManifest(dynamic content) async {
    await _localStorageClient.writeJsonToStorage('projects.json', content);
    return getProjectManifest();
  }

  Future<dynamic> getProjectManifest({force = false}) async {
    if (_manifestCache == null || force) {
      return _localStorageClient.getJsonFromStorage('projects.json');
    }

    return _manifestCache;
  }

  Future<dynamic> getFromManifest(String key) async {
    dynamic manifestJson = await getProjectManifest();

    return manifestJson['projects'];
  }

  Future<String> getProjectRoot(projectId) async {
    return (await _localStorageClient.createStorageDirectory(projectId)).path;
  }

  Future<dynamic> getFromProjectRoot(projectId, String fileName) async {
    String folder = await getProjectRoot(projectId);
    return _localStorageClient.getJsonFileAtPath('$folder/$fileName');
  }

  Future<File> writeToProjectRoot(String projectId, String fileName, dynamic content) async {
    String folder = await getProjectRoot(projectId);
    return _localStorageClient.writeJsonFileAtPath('$folder/$fileName', content);
  }
}
