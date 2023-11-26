import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:storied/domain/project/storage/storage_ref.dart';

class LocalStorageClient {
  Future<Directory> get _storageDir async {
    final Directory directory = await getApplicationDocumentsDirectory();
    debugPrint('Getting files from ${directory.path}');

    return directory;
  }

  Future<String> get _storageDirPath async {
    return (await _storageDir).path;
  }

  Future<List<String>> listFiles({String? path}) async {
    String resolvedPath = '${await _storageDirPath}/${path ?? ''}';
    final List<String> list = await Directory(resolvedPath)
        .list(recursive: false, followLinks: false)
        .map((file) => file.path.replaceFirst(resolvedPath, ''))
        .toList();
    return list;
  }

  Future<String?> getFileData(String path) async {
    var file = File('${await _storageDirPath}/$path');
    if (!file.existsSync()) {
      return null;
    }

    return await file.readAsString();
  }

  createDir(String dirName) async {
    Directory newDir = Directory('${await _storageDirPath}/$dirName');

    await newDir.create();
    return StorageReference(path: newDir.path, type: StorageAdapterType.local);
  }

  Future<File> writeFile(String path, dynamic data) async {
    var file = File('${await _storageDirPath}/$path');
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    return file.writeAsString(data);
  }

  Future<bool> deleteDir(String dirName) async {
    Directory dirRef = Directory('${await _storageDirPath}/$dirName');

    return dirRef.exists().then((exists) async {
      if (exists) {
        await dirRef.delete(recursive: true);
      }
      return true;
    });
  }
}
