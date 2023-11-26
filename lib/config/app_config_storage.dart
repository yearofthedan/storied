import 'dart:convert';
import 'package:storied/clients/local_storage_client.dart';
import 'package:storied/config/get_it.dart';

class AppConfigStorage {
  LocalStorageClient get _localStorage => getIt<LocalStorageClient>();

  List<dynamic> projectsJson = List.of([]);

  dynamic _manifestCache;

  Future<AppConfigStorage> warm() async {
    _manifestCache = await getProjectManifest(force: true);
    projectsJson = await getFromManifest('projects');
    return this;
  }

  Future<dynamic> overwriteProjectManifest(dynamic content) async {
    await _localStorage.writeFile('projects.json', jsonEncode(content));
    return getProjectManifest();
  }

  Future<dynamic> getProjectManifest({force = false}) async {
    if (_manifestCache == null || force) {
      var result = await _localStorage.getFileData('projects.json');

      if (result != null) {
        return jsonDecode(result);
      }
      var emptyManifestData = {'projects': []};
      await _localStorage.writeFile(
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
    return (await _localStorage.createDir(projectId)).path;
  }

  Future<dynamic> writeToProjectRoot(
      String projectId, String fileName, dynamic content) async {
    return _localStorage.writeFile('$projectId/$fileName', jsonEncode(content));
  }
}
