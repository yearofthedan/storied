import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorage {
  Future<Directory> get directory async {
    final directory = await getApplicationDocumentsDirectory();

    return directory;
  }

  Future<String> get directoryPath async {
    return (await directory).path;
  }

  Future<List<String>> get directoryListPaths async {
    return (await directory)
        .list(recursive: false, followLinks: false)
        .map((event) => event.path)
        .toList();
  }

  Future<File> getFile(String fileName) async {
    final path = await directory;
    return File('$path/$fileName');
  }

  Future<bool> exists(String fileName) async {
    File file = await getFile(fileName);
    return file.exists();
  }

  Future<dynamic> getJson(String fileName) async {
    File file = await getFile(fileName);
    return jsonDecode(await file.readAsString());
  }

  Future<File> writeString(String fileName, dynamic content) async {
    final fileRef = await getFile(fileName);

    return fileRef.writeAsString(content);
  }

  Future<File> writeJson(String fileName, dynamic content) async {
    return writeString(fileName, jsonEncode(content));
  }
}
