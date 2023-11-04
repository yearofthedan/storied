import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/_test_helpers/find_extensions.dart';
import 'package:storied/_test_helpers/tester_extensions.dart';
import 'package:storied/common/get_it.dart';
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

    createWidgetUnderTest(WidgetTester tester) async {
      var projectStorage = MockProjectStorage();
      var project = Project.newWithName('some project');
      getIt.registerSingleton<ProjectStorage>(projectStorage);
      getIt.registerSingleton<Project>(project);

      await tester.pumpWidget(const MaterialApp(
        home: SettingsScreen(),
      ));
      await tester.pumpAndSettle();
      return projectStorage;
    }

    testWidgets('displays the project title', (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      find.findByText(settingLabelTitle);
      find.findByText('some project');
    });

    testWidgets('supports deleting', (WidgetTester tester) async {
      var projectStorage = await createWidgetUnderTest(tester);
      when(() => projectStorage.delete(any()))
          .thenAnswer((_) => Future.value());

      find.findByText(settingLabelTitle);
      var delete = find.findByText(deleteProjectActionLabel);

      await tester.tapAndSettle(delete);
      find.findByText(deleteProjectAlertTitle);

      var confirm = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text(deleteProjectConfirmActionLabel));

      expect(confirm, findsOneWidget);

      await tester.tapAndSettle(confirm);
      verify(() => projectStorage.delete(any())).called(1);
      expect(confirm, findsNothing);
    });

    testWidgets('supports cancelling a delete', (WidgetTester tester) async {
      var projectStorage = await createWidgetUnderTest(tester);
      when(() => projectStorage.delete(any()))
          .thenAnswer((_) => Future.value());

      find.findByText(settingLabelTitle);
      var delete = find.findByText(deleteProjectActionLabel);

      await tester.tapAndSettle(delete);
      find.findByText(deleteProjectAlertTitle);

      var cancel = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text(deleteProjectCancelActionLabel));

      expect(cancel, findsOneWidget);

      await tester.tapAndSettle(cancel);
      verifyNever(() => projectStorage.delete(any()));
      expect(cancel, findsNothing);
    });
  });
}

class MockProjectStorage extends Mock implements ProjectStorage {}
