import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:storied/_test_helpers/storage.dart';
import 'package:storied/common/storage/clients/local_storage_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

const root = 'root/com.app';

void main() {
  setUp(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform(root);
  });

  group('writeFile', () {
    test('writes data to a file', () async {
      var mockFileReference = FakeFile();
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
      var dir = FakeDirectory();
      IOOverrides.runZoned(() async {
        final storage = LocalStorageClient();
        when(() => dir.create()).thenAnswer((_) => Future.value(dir));

        var result = await storage.createDir('new dir');

        verify(() => dir.create()).called(1);
        expect(result, dir);
      });
    });
  });

  group('listFiles', () {
    test('returns a list of filenames', () async {
      IOOverrides.runZoned(() async {
        final storage = LocalStorageClient();

        var result = await storage.listFiles();

        expect(result, ['file_2.json']);
      }, createDirectory: (path) => FakeDirectory());
    });
  });
}

class FakeFile extends Mock implements File {}

class FakeDirectory extends Mock implements Directory {
  @override
  String get path => root;
  @override
  Stream<FileSystemEntity> list(
      {bool recursive = false, bool followLinks = true}) {
    return Stream.fromIterable([File('$root/file_2.json')]);
  }
}
