import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/_test_helpers/find_extensions.dart';
import 'package:storied/_test_helpers/tester_extensions.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/domain/_mocks/project_storage.dart';
import 'package:storied/domain/project.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/domain/project_storage.dart';
import 'package:storied/features/project/settings/settings_screen.dart';
import 'package:storied/features/project/settings/terms.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(SettingsScreen, () {
    setUp(() async {
      getIt.reset();
      registerFallbackValue(Project.newWithName('some project'));
    });

    createWidgetUnderTest(WidgetTester tester, Project project) async {
      var projectStorage = MockProjectStorage();
      getIt.registerSingleton<ProjectStorage>(projectStorage);
      getIt.registerSingleton<Project>(project);

      await tester.pumpWidget(const MaterialApp(
        home: SettingsScreen(),
      ));
      await tester.pumpAndSettle();
      return projectStorage;
    }

    testWidgets('displays the project title', (WidgetTester tester) async {
      var project = Project.newWithName('some project');
      await createWidgetUnderTest(tester, project);

      find.findByText(settingEntry_TitleLabel);
      find.findByText('some project');
    });

    testWidgets('supports deleting', (WidgetTester tester) async {
      var project = Project.newWithName('some project');

      var projectStorage = await createWidgetUnderTest(tester, project);
      when(() => projectStorage.delete(any())).thenAnswer((_) {
        return Future.value(true);
      });

      find.findByText(settingEntry_TitleLabel);

      await tester.tapAndSettle(find.findByText(deleteProjectAction_Label));
      find.findByText(deleteProjectConfirmation_Title);

      var confirm = find
          .within(find.byType(AlertDialog))
          .findByText(deleteProjectConfirmation_ConfirmLabel);

      expect(confirm, findsOneWidget);

      await tester.tapAndSettle(confirm);

      find.findByText(deleteProjectAction_SuccessText);
      verify(() => projectStorage.delete(any())).called(1);
      expect(confirm, findsNothing);
    });

    testWidgets('supports cancelling a delete', (WidgetTester tester) async {
      var project = Project.newWithName('some project');
      var projectStorage = await createWidgetUnderTest(tester, project);

      find.findByText(settingEntry_TitleLabel);
      var delete = find.findByText(deleteProjectAction_Label);

      await tester.tapAndSettle(delete);
      find.findByText(deleteProjectConfirmation_Title);

      var cancel = find
          .within(find.byType(AlertDialog))
          .findByText(deleteProjectConfirmation_CancelLabel);

      expect(cancel, findsOneWidget);

      await tester.tapAndSettle(cancel);
      verifyNever(() => projectStorage.delete(any()));
      expect(cancel, findsNothing);
    });
  });
}
