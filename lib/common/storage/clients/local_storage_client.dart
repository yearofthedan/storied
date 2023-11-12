import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:storied/common/storage/clients/abstract_storage_client.dart';
import 'package:storied/domain/storage_ref.dart';

class LocalStorageClient implements AbstractStorageClient {
  Future<Directory> get _storageDir async {
    final Directory directory = await getApplicationDocumentsDirectory();
    debugPrint('Getting files from ${directory.path}');

    return directory;
  }

  Future<String> get _storageDirPath async {
    return (await _storageDir).path;
  }

  @override
  Future<List<String>> listFiles({String? path}) async {
    String resolvedPath = '${await _storageDirPath}/${path ?? ''}';
    final List<String> list = await Directory(resolvedPath)
        .list(recursive: false, followLinks: false)
        .map((file) => file.path.replaceFirst(resolvedPath, ''))
        .toList();
    return list;
  }

  @override
  Future<dynamic> getFileData(String path, {Function(String)? decoder}) async {
    var file = File('${await _storageDirPath}/$path');
    if (!file.existsSync()) {
      return null;
    }

    dynamic data = await file.readAsString();
    return decoder == null ? data : decoder(data);
  }

  @override
  createDir(String dirName) async {
    Directory newDir = Directory('${await _storageDirPath}/$dirName');

    await newDir.create();
    return StorageRef(path: newDir.path, type: StorageType.local);
  }

  @override
  Future<File> writeFile(String path, dynamic data) async {
    var file = File('${await _storageDirPath}/$path');
    return file.writeAsString(data);
  }

  @override
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
