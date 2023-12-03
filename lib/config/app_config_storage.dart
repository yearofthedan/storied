import 'dart:convert';
import 'package:storied/clients/local_storage_client.dart';
import 'package:storied/config/get_it.dart';

class AppConfigStorage {
  LocalStorageClient get _localStorage => getIt<LocalStorageClient>();
  String manifestFileName = 'manifest.json';

  dynamic _manifestCache;

  Future<AppConfigStorage> warm() async {
    _manifestCache = await getAppManifest(force: true);
    return this;
  }

  Future<dynamic> overwriteAppManifest(dynamic content) async {
    await _localStorage.writeFile(manifestFileName, jsonEncode(content));
    _manifestCache = await getAppManifest();
    return _manifestCache;
  }

  Future<dynamic> getAppManifest({force = false}) async {
    if (_manifestCache == null || force) {
      String? result = await _localStorage.getFileData(manifestFileName);

      if (result != null) {
        return jsonDecode(result);
      }
      var emptyManifestData = {'projects': []};
      await _localStorage.writeFile(
          manifestFileName, jsonEncode(emptyManifestData));
      return emptyManifestData;
    }

    return _manifestCache;
  }

  Future<List<dynamic>> getFromAppManifest(String key) async {
    dynamic manifestJson = await getAppManifest();

    return manifestJson[key];
  }

  Future<dynamic> setToAppManifest(String key, dynamic value) async {
    dynamic manifestJson = await getAppManifest();

    manifestJson[key] = value;
    return await overwriteAppManifest(manifestJson);
  }
}
