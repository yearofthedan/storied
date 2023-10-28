import 'dart:io';

import 'package:storied/storage/local_storage_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import '../_helpers/storage.dart';

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

        var result = await storage.getFileNames(type: 'json ');

        expect(result, ['$root/file_2.json']);
      }, createDirectory: (path) => FakeDirectory());
    });

    test('getApplicationDocumentsDirectory', () async {
      final storage = LocalStorageClient();

      expect((await storage.storageDir).path, root);
    });
  });
}

class FakeDirectory extends Fake implements Directory {
  @override
  String get path => root;
  @override
  Stream<FileSystemEntity> list({bool recursive = false, bool followLinks = true}) {
    return Stream.fromIterable([File('$root/file_1.unknown'), File('$root/file_2.json')]);
  }
}
