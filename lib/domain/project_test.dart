import 'package:mocktail/mocktail.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/common/storage/_mocks/app_config.dart';
import 'package:storied/common/storage/_mocks/storage_client.dart';
import 'package:storied/common/storage/app_storage.dart';
import 'package:storied/common/storage/clients/local_storage_client.dart';
import 'package:storied/domain/project.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/domain/project_storage.dart';
import 'package:uuid/uuid.dart';

const root = 'root/com.app';

void main() {
  setUp(() {
    getIt.reset();
  });
  group(Project, () {
    group('newWithName', () {
      test('creates from a name and generates an id', () async {
        var project = Project.newWithName('some name');

        expect(project.name, 'some name');
        expect(Uuid.isValidUUID(fromString: project.id), true);
      });
    });

    group('delete', () {
      test('deletes from storage', () async {
        var mockStorageClient = MockStorageClient();
        var mockAppConfig = MockAppConfig();

        getIt.registerSingleton<ProjectStorage>(ProjectStorage());
        getIt.registerSingleton<AppConfig>(mockAppConfig);
        getIt.registerSingleton<StorageClient>(mockStorageClient);
        var project = Project.newWithName('some name');

        when(() => mockStorageClient.deleteDir(project.id))
            .thenAnswer((_) => Future.value(true));
        when(() => mockAppConfig.setToManifest('projects', any()))
            .thenAnswer((_) => Future.value());

        var result = await project.delete();

        expect(result.deleted, true);
      });
    });
  });
}
