import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Asset {
  String assetName;

  Asset(this.assetName);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$assetName');
  }

  Future<dynamic> get jsonContent async {
    final fileRef = await _localFile;

    if (!(await fileRef.exists())) {
      await setJsonContent(r'[{"insert":"hello\n"}]');
    }

    return jsonDecode(await fileRef.readAsString());
  }

  Future<File> setJsonContent(dynamic content) async {
    final fileRef = await _localFile;

    return fileRef.writeAsString(jsonEncode(content));
  }
}
