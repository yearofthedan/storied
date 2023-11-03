import 'dart:io';

import 'package:storied/_test_helpers/storage.dart';
import 'package:storied/common/storage/clients/local_storage_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('getFileNames', () {
    setUp(() async {
      PathProviderPlatform.instance = FakePathProviderPlatform(root);
    });
    test('returns a list of filenames', () async {
      IOOverrides.runZoned(() async {
        final storage = LocalStorageClient();

        var result = await storage.listFiles();

        expect(result, ['file_2.json']);
      }, createDirectory: (path) => FakeDirectory());
    });
  });
}

class FakeDirectory extends Fake implements Directory {
  @override
  String get path => root;
  @override
  Stream<FileSystemEntity> list(
      {bool recursive = false, bool followLinks = true}) {
    return Stream.fromIterable([File('$root/file_2.json')]);
  }
}
