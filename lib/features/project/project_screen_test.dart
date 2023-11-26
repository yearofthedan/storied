import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/_test_helpers/tester_extensions.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/domain/document/_mocks/document.dart';
import 'package:storied/domain/project/_mocks/project_storage.dart';
import 'package:storied/domain/project/project.dart';
import 'package:storied/domain/project/project_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:storied/features/project/document/document_page.dart';
import 'package:storied/features/project/settings/settings_screen.dart';
import 'package:storied/features/project/project_screen.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(ProjectScreen, () {
    setUp(() async {
      getIt.reset();
    });

    createWidgetUnderTest(WidgetTester tester, Project project) async {
      getIt.registerLazySingleton<ProjectStorageAdapterConfig>(() {
        MockLocalProjectStorage storage = MockLocalProjectStorage();

        when(() => storage.getDocument(project.storage.path)).thenAnswer((_) {
          return Future.value(buildDocument());
        });
        return ProjectStorageAdapterConfig(
            {StorageAdapterType.local: () => storage});
      });

      getIt.registerSingleton<Project>(project);
      await tester.pumpWidget(MaterialApp(
        home: ProjectScreen(project),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('renders the title and the document page',
        (WidgetTester tester) async {
      await createWidgetUnderTest(
        tester,
        buildProject(name: 'Some project name'),
      );
      expect(find.text('Some project name'), findsOneWidget);
      expect(find.byType(DocumentPage), findsOneWidget);
    });

    testWidgets('can navigate to the settings screen',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester, buildProject());

      await tester.tapAndSettle(find.byTooltip('Settings'));

      expect(find.byType(SettingsScreen), findsOneWidget);
    });
  });
}
