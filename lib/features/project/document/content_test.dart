import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/common/storage/clients/abstract_storage_client.dart';
import 'package:storied/features/project/document/content.dart';

class MockStorageClient extends Mock implements AbstractStorageClient {}

void main() {
  group('Content', () {
    late Content content;
    late MockStorageClient mockStorageClient;

    setUp(() {
      mockStorageClient = MockStorageClient();
      content = Content<String>(mockStorageClient, 'path/to/file',
          decoder: (value) => value, encoder: (value) => value);
    });

    group('load', () {
      test('loads content from storage', () async {
        dynamic expectedContent = 'some content';
        when(() => mockStorageClient.getFileData('path/to/file'))
            .thenAnswer((_) => Future.value(expectedContent));

        final result = await content.load();

        expect(result, equals(expectedContent));
      });

      test('stores the loaded content in memory to reduce i/o', () async {
        dynamic expectedContent = 'some content';
        when(() => mockStorageClient.getFileData('path/to/file'))
            .thenAnswer((_) => Future.value(expectedContent));

        await content.load();

        expect(content.data, equals(expectedContent));
      });
    });

    group('write', () {
      test('saves content to the storage client', () async {
        const testContent = 'some content';

        when(() => mockStorageClient.writeFile('path/to/file', testContent))
            .thenAnswer((_) => Future.value(MockFile()));

        var result = await content.save(testContent);

        expect(result, true);
      });

      test('updates content in memory after saving', () async {
        const testContent = 'some content';

        when(() => mockStorageClient.writeFile('path/to/file', testContent))
            .thenAnswer((_) => Future.value(MockFile()));

        expect(content.data, equals(null));

        await content.save(testContent);

        expect(content.data, testContent);
      });
    });
  });
}

class MockFile extends Mock implements File {}
