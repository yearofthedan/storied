import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/_test_helpers/find_extensions.dart';
import 'package:storied/_test_helpers/tester_extensions.dart';
import 'package:storied/clients/_mocks/google_apis_mocks.dart';
import 'package:storied/clients/_mocks/local_storage_client.dart';
import 'package:storied/clients/google_apis_provider.dart';
import 'package:storied/clients/local_storage_client.dart';
import 'package:storied/config/_mocks/app_config.dart';
import 'package:storied/config/app_config.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/domain/project/project.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:storied/features/add_project/add_project_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/domain/projects.dart';
import 'package:storied/features/add_project/new_project.dart';
import 'package:storied/common/i18n/strings.g.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(AddProjectScreen, () {
    Project? added;
    LocalStorageClient? localStorage;
    GoogleApisProvider? gDriveStorage;

    setUp(() async {
      localStorage = MockLocalStorageClient();
      gDriveStorage = MockGoogleApisProvider();

      getIt.registerLazySingleton<ProjectStorageAdapterConfig>(() {
        var config = ProjectStorageAdapterConfig();
        config.enableOption(StorageAdapterType.gdrive);
        return config;
      });
      getIt.registerLazySingleton<AppConfig>(() {
        var mockAppConfig = MockAppConfig();
        when(() => mockAppConfig.getProjectList())
            .thenAnswer((_) => Future.value([]));
        return mockAppConfig;
      });
      getIt.registerSingleton<LocalStorageClient>(localStorage!);
      getIt.registerSingleton<GoogleApisProvider>(gDriveStorage!);
      getIt.registerFactory<Projects>(() {
        return Projects([]);
      });

      registerFallbackValue(NewProject('dummy', StorageAdapterType.local));
    });

    tearDown(() => getIt.reset());

    createWidgetUnderTest(WidgetTester tester) async {
      onAdded(Project project) => {added = project};

      await tester.pumpWidget(MaterialApp(
        home: AddProjectScreen(onAdded),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('allows adding a local project as default',
        (WidgetTester tester) async {
      when(() => localStorage!.createDir(any<String>()))
          .thenAnswer((invocation) => Future.value('some/path'));
      await createWidgetUnderTest(tester);

      var field = find.findWidgetWithText(t.addProject.projectNameFieldLabel);
      await tester.enterText(field, 'my project');
      await tester.tapAndSettle(
          find.findByText(t.addProject.storageField.localOptionLabel));
      await tester.tapAndSettle(find.findByText(t.common.createAction));

      expect(added?.name, 'my project');
      expect(added?.storage.type, StorageAdapterType.local);
    });

    testWidgets('allows adding a gdrive project when linked',
        (WidgetTester tester) async {
      when(() => gDriveStorage!.createDir(any<String>()))
          .thenAnswer((invocation) => Future.value('some-id'));

      await createWidgetUnderTest(tester);

      var field = find.findWidgetWithText(t.addProject.projectNameFieldLabel);
      await tester.enterText(field, 'my project');
      await tester.tapAndSettle(
          find.findByText(t.addProject.storageField.gDriveOptionLabel));
      await tester.tapAndSettle(find.findByText(t.common.createAction));

      expect(added?.name, 'my project');
      expect(added?.storage.type, StorageAdapterType.gdrive);
    });
  });
}
