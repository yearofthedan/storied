import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/_test_helpers/find_extensions.dart';
import 'package:storied/_test_helpers/tester_extensions.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/domain/project/_mocks/project_storage.dart';
import 'package:storied/domain/project/project.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:storied/features/project/settings/settings_screen.dart';
import 'package:storied/features/project/settings/terms.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(SettingsScreen, () {
    setUp(() async {
      getIt.reset();
    });

    createWidgetUnderTest(WidgetTester tester, Project project) async {
      getIt.registerSingleton<ProjectStorageAdapterConfig>(
          ProjectStorageAdapterConfig());

      getIt.registerSingleton<Project>(project);

      await tester.pumpWidget(const MaterialApp(
        home: SettingsScreen(),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('displays the project title', (WidgetTester tester) async {
      var project = buildProject(name: 'some project');
      await createWidgetUnderTest(tester, project);

      find.findByText(settingEntry_TitleLabel);
      find.findByText('some project');
    });

    testWidgets('supports deleting', (WidgetTester tester) async {
      var mockProjectStorage = MockProjectStorage();
      when(() => mockProjectStorage.delete())
          .thenAnswer((_) => Future.value(true));

      var project =
          buildProject(name: 'some project', storage: mockProjectStorage);

      await createWidgetUnderTest(tester, project);

      find.findByText(settingEntry_TitleLabel);

      await tester.tapAndSettle(find.findByText(deleteProjectAction_Label));
      find.findByText(deleteProjectConfirmation_Title);

      var confirm = find
          .within(find.byType(AlertDialog))
          .findByText(deleteProjectConfirmation_ConfirmLabel);

      expect(confirm, findsOneWidget);

      await tester.tapAndSettle(confirm);

      find.findByText(deleteProjectAction_SuccessText);
      expect(confirm, findsNothing);
      expect(project.deleted, true);
    });

    testWidgets('supports cancelling a delete', (WidgetTester tester) async {
      var project = buildProject(name: 'some project');
      await createWidgetUnderTest(tester, project);

      find.findByText(settingEntry_TitleLabel);
      var delete = find.findByText(deleteProjectAction_Label);

      await tester.tapAndSettle(delete);
      find.findByText(deleteProjectConfirmation_Title);

      var cancel = find
          .within(find.byType(AlertDialog))
          .findByText(deleteProjectConfirmation_CancelLabel);

      expect(cancel, findsOneWidget);

      await tester.tapAndSettle(cancel);
      expect(project.deleted, false);
      expect(cancel, findsNothing);
    });
  });
}
