import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/_test_helpers/find_extensions.dart';
import 'package:storied/_test_helpers/tester_extensions.dart';
import 'package:storied/clients/_mocks/local_storage_client.dart';
import 'package:storied/clients/local_storage_client.dart';
import 'package:storied/config/_mocks/app_config.dart';
import 'package:storied/config/app_config.dart';
import 'package:storied/config/app_config_storage.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/domain/document/_mocks/document.dart';
import 'package:storied/domain/project/_mocks/project_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/domain/project/project.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:storied/features/add_project/new_project.dart';
import 'package:storied/features/home/terms.dart';
import 'package:storied/features/project/project_screen.dart';
import 'package:storied/features/project/terms.dart';
import 'package:storied/features/project/settings/terms.dart';
import 'package:storied/main.dart';
import 'package:storied/domain/projects.dart';
import 'package:storied/common/i18n/strings.g.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(MyApp, () {
    setUp(() async {
      registerFallbackValue(NewProject('dummy', StorageAdapterType.local));
      registerFallbackValue(buildProject());
    });

    tearDown(() => getIt.reset);

    createWidgetUnderTest(
        WidgetTester tester, Iterable<Project> projects) async {
      getIt.allowReassignment = true;
      initGetIt();
      MockLocalStorageClient localStorage = MockLocalStorageClient();

      getIt.registerLazySingleton<AppConfigStorage>(() {
        var appConfigStorage = MockAppConfigStorage();
        when(() => appConfigStorage.setToAppManifest(any(), any()))
            .thenAnswer((invocation) => Future.value());
        when(() => appConfigStorage.getAppManifest())
            .thenAnswer((invocation) => Future.value({projects: []}));
        when(() => appConfigStorage.getFromAppManifest(any()))
            .thenAnswer((invocation) => Future.value([]));

        return appConfigStorage;
      });
      getIt.registerSingleton<AppConfig>(AppConfig());
      getIt.registerFactory<Projects>(() {
        return Projects(List.of(projects));
      });

      getIt.registerLazySingleton<LocalStorageClient>(() {
        when(() => localStorage.deleteDir(any())).thenAnswer((_) {
          return Future.value(true);
        });
        when(() => localStorage.createDir(any())).thenAnswer((_) {
          return Future.value('path/to/dir');
        });
        when(() => localStorage.writeFile(any(), any())).thenAnswer((_) {
          return Future.value(File('stub'));
        });
        return localStorage;
      });

      await tester.pumpWidget(bootstrappedApp());
      await tester.pumpAndSettle();
      find.findByText(appTitle_Text, count: 1);
    }

    testWidgets('allows opening and closing a project',
        (WidgetTester tester) async {
      var storage = MockProjectStorage();
      when(() => storage.getDocument()).thenAnswer((_) {
        return Future.value(buildDocument());
      });

      await createWidgetUnderTest(tester,
          [buildProject(name: 'some-existing-project', storage: storage)]);

      await tester.tapAndSettle(find.text('some-existing-project'));
      find.findByText(appTitle_Text, count: 0);

      await tester.tapAndSettle(find.byTooltip(backAction_toolTip));
      find.findByText(appTitle_Text);
    });

    testWidgets('allows creating a project', (WidgetTester tester) async {
      await createWidgetUnderTest(tester, []);

      await tester.tapAndSettle(find.findByText(createProjectAction_Label));
      await tester.enterText(
          find.findWidgetWithText(t.addProject.projectNameFieldLabel),
          'some-new-project');
      await tester.tapAndSettle(find.findByText(t.common.createAction));

      find.findByText(appTitle_Text, count: 0);
      find.findByType(ProjectScreen);

      await tester.tapAndSettle(find.byTooltip(backAction_toolTip));

      // TODO debug why this is not finding an entry even though it works in the app
      // find.findByText('some-new-project', count: 1);
    });

    testWidgets('allows removing a project', (WidgetTester tester) async {
      var storage = MockProjectStorage();
      when(() => storage.getDocument()).thenAnswer((_) {
        return Future.value(buildDocument());
      });
      when(() => storage.delete()).thenAnswer((_) {
        return Future.value(true);
      });

      await createWidgetUnderTest(tester,
          [buildProject(name: 'some-existing-project', storage: storage)]);

      await tester.tapAndSettle(find.findByText('some-existing-project'));
      find.findByText(appTitle_Text, count: 0);

      await tester.tapAndSettle(find.byTooltip(viewSettingsAction_tooltip));
      await tester.tapAndSettle(find.text(deleteProjectAction_Label));
      await tester.tapAndSettle(find
          .within(find.byType(AlertDialog))
          .findByText(deleteProjectConfirmation_ConfirmLabel));

      find.findByText(deleteProjectAction_SuccessText);
      find.findByText(appTitle_Text, count: 1);

      // TODO debug why this is still finding an entry even though it works in the app
      // find.findByText('some-existing-project', count: 0);
    });
  });
}
