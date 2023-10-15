import 'dart:convert';
import 'dart:io';

import 'package:storied/config/app_config.dart';
import 'package:storied/storage/local_storage_client.dart';
import 'package:flutter_test/flutter_test.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('getConfig', () {
    test('returns projects if they exist', () async {
      var config = await AppConfigFactory.loadConfig(AppStorage(
          FakeLocalStorageClient('{"projects": [{"name":"a project"}]}')));

      expect(config.projects.length, 1);
    });

    test('returns default config if missing', () async {
      var config = await AppConfigFactory.loadConfig(
          AppStorage(FakeLocalStorageClient(null)));

      expect(config.projects.length, 0);
    });
  });
}

class FakeLocalStorageClient extends Fake implements LocalStorageClient {
  String? _content;

  FakeLocalStorageClient(this._content);
  @override
  Future getJsonFromStorage(String fileName) {
    if (_content != null) {
      return Future.value(jsonDecode(_content!));
    }
    return Future.value(null);
  }

  @override
  Future<File> writeJsonToStorage(String fileName, dynamic content) {
    _content = jsonEncode(content);
    return Future.value(File(fileName));
  }
}
