import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/domain/document/document.dart';
import 'package:storied/domain/project/_mocks/project_storage.dart';

void main() {
  group(Document, () {
    late Document document;
    late MockProjectStorage storage;
    setUp(() {
      storage = MockProjectStorage();

      document = Document([], storage);
    });

    tearDown(() => getIt.reset());

    group('write', () {
      test('marks as dirty after writing', () async {
        document.data = ['some doc data'];

        expect(document.dirty, true);
      });

      test('saves data to the storage client', () async {
        const docData = ['some doc data'];
        when(() => storage.saveDocument(docData))
            .thenAnswer((_) => Future.value(document));

        document.data = docData;
        var result = await document.save();

        expect(result, document);
        expect(result.dirty, false);
      });
    });
  });
}
