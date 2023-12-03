import 'package:mocktail/mocktail.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/domain/project/_mocks/project_storage.dart';
import 'package:storied/domain/project/project.dart';
import 'package:flutter_test/flutter_test.dart';

const root = 'root/com.app';

void main() {
  setUp(() {
    getIt.reset();
  });
  group(Project, () {
    group('delete', () {
      test('deletes from storage', () async {
        var storage = MockProjectStorage();
        var project = buildProject(storage: storage);

        when(() => storage.delete()).thenAnswer((_) => Future.value(true));

        var result = await project.delete();

        expect(result.deleted, true);
      });
    });
  });
}
