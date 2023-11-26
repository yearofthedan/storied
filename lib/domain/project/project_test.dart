import 'package:mocktail/mocktail.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/domain/project/_mocks/project_storage.dart';
import 'package:storied/domain/project/project.dart';
import 'package:storied/domain/project/storage/_mocks/project_storage.dart';
import 'package:storied/domain/project/storage/local_project_storage_adapter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';

const root = 'root/com.app';

class MockLocalProjectStorage extends Mock
    implements LocalProjectStorageAdapter {}

void main() {
  setUp(() {
    getIt.reset();
  });
  group(Project, () {
    group('delete', () {
      test('deletes from storage', () async {
        var storageConfig = MockProjectStorageAdapterConfig();
        getIt.registerSingleton<ProjectStorageAdapterConfig>(storageConfig);
        var project = buildProject();
        when(() => storageConfig.adapter.delete(project))
            .thenAnswer((_) => Future.value(true));

        var result = await project.delete();

        expect(result.deleted, true);
      });
    });
  });
}
