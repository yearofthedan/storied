import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/_test_helpers/find_extensions.dart';
import 'package:storied/_test_helpers/tester_extensions.dart';
import 'package:storied/config/_mocks/app_config.dart';
import 'package:storied/config/app_config.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/domain/project/_mocks/project_storage.dart';
import 'package:storied/domain/project/project.dart';
import 'package:storied/domain/project/storage/_mocks/project_storage.dart';
import 'package:storied/domain/project/storage/project_storage_adapter.dart';
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
    ProjectStorageAdapter? localStorage;
    ProjectStorageAdapter? gDriveStorage;

    setUp(() async {
      localStorage = MockProjectStorageAdapter();
      gDriveStorage = MockProjectStorageAdapter();

      var storageConfig = ProjectStorageAdapterConfig({
        StorageAdapterType.local: () => localStorage!,
        StorageAdapterType.gdrive: () => gDriveStorage!,
      });
      getIt.registerSingleton<ProjectStorageAdapterConfig>(storageConfig);
      getIt.registerSingleton<AppConfig>(MockAppConfig());

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
      when(() => localStorage!.add(any<NewProject>())).thenAnswer(
          (invocation) => Future.value(
              buildProject(name: invocation.positionalArguments[0].name)));
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
      when(() => gDriveStorage!.add(any<NewProject>())).thenAnswer(
          (invocation) => Future.value(buildProject(
              name: invocation.positionalArguments[0].name,
              storage: buildStorageRef(type: StorageAdapterType.gdrive))));
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
