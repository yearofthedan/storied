import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:storied/_test_helpers/storage.dart';
import 'package:storied/common/storage/app_config_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:storied/common/storage/clients/local_storage_client.dart';

import '../get_it.dart';

const root = 'root/com.app';

void main() {
  setUp(() async {
    getIt.reset();
    PathProviderPlatform.instance = FakePathProviderPlatform(root);
  });

  group(AppConfigStorage, () {
    group('getProjectManifest', () {
      test('gets a project manifest if it exists', () async {
        var localStorage =
            getIt.registerSingleton<LocalStorageClient>(LocalStorageClient());

        var mockFileReference = FakeFile();
        when(() => mockFileReference.existsSync()).thenReturn(true);
        when(() => mockFileReference.readAsString())
            .thenAnswer((_) => Future.value('{"projects":[]}'));

        IOOverrides.runZoned(() async {
          final storage = AppConfigStorage(localStorage);
          var result = await storage.getProjectManifest();

          expect(result, {'projects': []});
        }, createFile: (_) => mockFileReference);
      });

      test('creates a new project manifest if none exists', () async {
        var localStorage =
            getIt.registerSingleton<LocalStorageClient>(LocalStorageClient());

        var mockFileReference = FakeFile();
        when(() => mockFileReference.existsSync()).thenReturn(false);
        when(() => mockFileReference.writeAsString('{"projects":[]}'))
            .thenAnswer((_) => Future.value(mockFileReference));
        when(() => mockFileReference.readAsString())
            .thenAnswer((_) => Future.value('{"projects":[]}'));

        IOOverrides.runZoned(() async {
          final storage = AppConfigStorage(localStorage);
          var result = await storage.getProjectManifest();

          expect(result, {'projects': []});
        }, createFile: (_) => mockFileReference);
      });
    });
  });
}

class FakeFile extends Mock implements File {}

class MockDirectory extends Mock implements Directory {
  @override
  String get path => root;
  @override
  Stream<FileSystemEntity> list(
      {bool recursive = false, bool followLinks = true}) {
    return Stream.fromIterable([File('$root/file_2.json')]);
  }
}
