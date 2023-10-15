import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageClient {
  Future<Directory> get storageDir async {
    final Directory directory = await getApplicationDocumentsDirectory();
    debugPrint('Getting files from ${directory.path}');

    return directory;
  }

  Future<String> get storageDirPath async {
    return (await storageDir).path;
  }

  Future<List<String>> get directoryListPaths async {
    final list = (await storageDir).list(recursive: false, followLinks: false);

    return list.map((file) => file.path).toList();
  }

  Future<List<String>> getFileNames({type = 'json'}) async {
    return (await directoryListPaths)
        .where((path) => path.endsWith('json'))
        .toList();
  }

  Future<dynamic> getJsonFileAtPath(String pathToFile) async {
    var file = File(pathToFile);
    if (!file.existsSync()) {
      return null;
    }
    return jsonDecode(await file.readAsString());
  }

  Future<Directory> createStorageDirectory(String dirName) async {
    Directory newDir = Directory('${await storageDirPath}/$dirName');

    return newDir.create();
  }

  Future<dynamic> getJsonFromStorage(String fileName) async {
    File file = File('${await storageDirPath}/$fileName');

    if (!file.existsSync()) {
      return null;
    }

    return jsonDecode(await file.readAsString());
  }

  Future<File> writeString(String fileName, dynamic content) async {
    final fileRef = File(fileName);

    return fileRef.writeAsString(content);
  }

  Future<File> writeJsonToStorage(String fileName, dynamic content) async {
    return writeString(
        '${await storageDirPath}/$fileName', jsonEncode(content));
  }

  Future<File> writeJsonFileAtPath(String pathToFile, dynamic content) async {
    return writeString(pathToFile, jsonEncode(content));
  }
}
