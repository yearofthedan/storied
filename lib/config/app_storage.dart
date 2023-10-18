import 'dart:io';

import 'package:storied/storage/local_storage_client.dart';

class AppStorage {
  final LocalStorageClient _localStorageClient;

  AppStorage(this._localStorageClient);

  Future<String> createNewProjectStorage(String projectId) async {
    return (await _localStorageClient.createStorageDirectory(projectId)).path;
  }

  Future<dynamic> overwriteProjectManifest(dynamic content) async {
    await _localStorageClient.writeJsonToStorage('projects.json', content);
    return getProjectManifest();
  }

  Future<dynamic> getProjectManifest() async {
    return _localStorageClient.getJsonFromStorage('projects.json');
  }

  Future<String> getProjectRoot(projectId) async {
    return (await _localStorageClient.createStorageDirectory(projectId)).path;
  }

  Future<dynamic> getFromProjectRoot(projectId, String fileName) async {
    String folder = await getProjectRoot(projectId);
    return _localStorageClient.getJsonFileAtPath('$folder/$fileName');
  }

  Future<File> writeToProjectRoot(
      String projectId, String fileName, dynamic content) async {
    String folder = await getProjectRoot(projectId);
    return _localStorageClient.writeJsonFileAtPath(
        '$folder/$fileName', content);
  }
}
