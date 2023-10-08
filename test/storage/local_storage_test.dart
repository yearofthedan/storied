import 'dart:io';

import 'package:bibi/storage/local_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('getFileNames', () {
    setUp(() async {
      PathProviderPlatform.instance = FakePathProviderPlatform();
    });
    test('returns a list of filenames', () async {
      IOOverrides.runZoned(() async {
        final storage = LocalStorage();

        var result = await storage.getFileNames(type: 'json ');

        expect(result, ['$root/file_2.json']);
      }, createDirectory: (path) => FakeDirectory());
    });

    test('getApplicationDocumentsDirectory', () async {
      final storage = LocalStorage();

      expect((await storage.directory).path, root);
    });
  });
}

class FakeDirectory extends Fake implements Directory {
  @override
  Stream<FileSystemEntity> list(
      {bool recursive = false, bool followLinks = true}) {

    return Stream.fromIterable([
      File('$root/file_1.unknown'),
      File('$root/file_2.json')
      ]);
  }
}

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return root;
  }
}
