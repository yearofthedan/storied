import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/domain/document/document.dart';
import 'package:storied/domain/project/storage/_mocks/project_storage.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:storied/domain/project/storage/storage_ref.dart';

void main() {
  group(Document, () {
    late Document document;
    late MockProjectStorageAdapter storage;
    setUp(() {
      registerFallbackValue(const StorageReference(
          path: 'path/to/file', type: StorageAdapterType.local));

      var storageConfig = MockProjectStorageAdapterConfig();
      getIt.registerSingleton<ProjectStorageAdapterConfig>(storageConfig);
      storage = storageConfig.adapter;

      document = Document(
          const StorageReference(
              path: 'path/to/file', type: StorageAdapterType.local),
          []);
    });

    tearDown(() => getIt.reset());

    group('write', () {
      test('marks as dirty after writing', () async {
        document.data = ['some doc data'];

        expect(document.dirty, true);
      });

      test('saves data to the storage client', () async {
        const docData = ['some doc data'];
        when(() => storage.saveDocument('path/to/file', docData))
            .thenAnswer((_) => Future.value(document));

        document.data = docData;
        var result = await document.save();

        expect(result, document);
        expect(result.dirty, false);
      });
    });
  });
}
