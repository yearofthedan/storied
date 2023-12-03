import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:storied/_test_helpers/storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:storied/clients/local_storage_client.dart';

const root = 'root/com.app';

void main() {
  setUp(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform(root);
  });

  group(LocalStorageClient, () {
    group('writeFile', () {
      test('writes data to a file', () async {
        var mockFileReference = FakeFile();
        when(() => mockFileReference.existsSync()).thenReturn(true);
        when(() => mockFileReference.writeAsString('some-data'))
            .thenAnswer((_) => Future.value(mockFileReference));

        IOOverrides.runZoned(() async {
          final storage = LocalStorageClient();
          var result = await storage.writeFile('path/to/file', 'some-data');

          expect(result, mockFileReference);
        }, createFile: (_) => mockFileReference);
      });
    });

    group('getFileData', () {
      test('returns the data from a file', () async {
        var mockFileReference = FakeFile();
        when(() => mockFileReference.existsSync()).thenReturn(true);
        when(() => mockFileReference.readAsString())
            .thenAnswer((_) => Future.value('tada'));

        IOOverrides.runZoned(() async {
          final storage = LocalStorageClient();
          var result = await storage.getFileData('a');

          expect(result, 'tada');
        }, createFile: (_) => mockFileReference);
      });

      test('returns null if the file does not exist', () async {
        var mockFileReference = FakeFile();
        when(() => mockFileReference.existsSync()).thenReturn(false);

        IOOverrides.runZoned(() async {
          final storage = LocalStorageClient();
          var result = await storage.getFileData('a');

          expect(result, null);
        }, createFile: (_) => mockFileReference);
      });
    });

    group('createDir', () {
      test('allows creating a folder', () async {
        var dir = MockDirectory();
        when(() => dir.create()).thenAnswer((_) => Future.value(dir));
        IOOverrides.runZoned(() async {
          final storage = LocalStorageClient();

          var result = await storage.createDir('new dir');
          expect(result, dir.path);
        }, createDirectory: (path) => dir);
      });
    });

    group('deleteDir', () {
      test('allows deleting a folder', () async {
        var dir = MockDirectory();
        when(() => dir.exists()).thenAnswer((invocation) => Future.value(true));
        when(() => dir.delete(recursive: true))
            .thenAnswer((invocation) => Future.value(dir));
        IOOverrides.runZoned(() async {
          final storage = LocalStorageClient();
          var result = await storage.deleteDir('new dir');

          expect(result, true);
        }, createDirectory: (path) => dir);
      });

      test('it returns true if the directory is missing', () async {
        var dir = MockDirectory();
        when(() => dir.exists()).thenAnswer((_) => Future.value(false));
        IOOverrides.runZoned(() async {
          final storage = LocalStorageClient();
          var result = await storage.deleteDir('new dir');

          expect(result, true);
          verifyNever(() => dir.delete(recursive: true));
        }, createDirectory: (path) => dir);
      });
    });

    group('listFiles', () {
      test('returns a list of filenames', () async {
        IOOverrides.runZoned(() async {
          final storage = LocalStorageClient();

          var result = await storage.listFiles();

          expect(result, ['file_2.json']);
        }, createDirectory: (path) => MockDirectory());
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
