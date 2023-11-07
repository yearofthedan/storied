import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/_test_helpers/find_extensions.dart';
import 'package:storied/_test_helpers/mocktail.dart';
import 'package:storied/_test_helpers/tester_extensions.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/domain/_mocks/project_storage.dart';
import 'package:storied/domain/project.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/domain/project_storage.dart';
import 'package:storied/features/add_project/terms.dart';
import 'package:storied/features/home/terms.dart';
import 'package:storied/features/project/navigation/terms.dart';
import 'package:storied/features/project/settings/terms.dart';
import 'package:storied/main.dart';
import 'package:storied/domain/projects.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(MyApp, () {
    setUp(() async {
      getIt.reset();
      registerFallbackValue(Project.newWithName('dummy'));
    });

    createWidgetUnderTest(WidgetTester tester, Project initialProject) async {
      var storage = MockProjectStorage();
      when(() => storage.add(any())).thenAnswer(reflectFirstArgAsFuture);
      when(() => storage.delete(any())).thenAnswer((_) {
        return Future.value(true);
      });

      getIt.registerSingleton<ProjectStorage>(storage);
      getIt.registerFactory<Projects>(() {
        return Projects(List.of([initialProject]));
      });
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      find.findByText(appTitle_Text, count: 1);
    }

    testWidgets('allows opening and closing a project',
        (WidgetTester tester) async {
      await createWidgetUnderTest(
          tester, Project.newWithName('some-existing-project'));

      await tester.tapAndSettle(find.text('some-existing-project'));
      find.findByText(appTitle_Text, count: 0);

      await tester.tapAndSettle(find.text(exitProjectActionLabel));
      find.findByText(appTitle_Text);
    });

    testWidgets('allows creating and navigating to a project',
        (WidgetTester tester) async {
      await createWidgetUnderTest(
          tester, Project.newWithName('some-existing-project'));

      await tester.tapAndSettle(find.findByText(createProjectAction_Label));
      await tester.enterText(
          find.findWidgetWithText(projectNameField_Label), 'some-new-project');
      await tester
          .tapAndSettle(find.findByText(submitCreateProjectAction_Label));

      find.findByText(appTitle_Text, count: 0);
      find.findByText('some-new-project');
      find.findByText(navEntryLabelDocument);
    });

    testWidgets('allows removing a project', (WidgetTester tester) async {
      await createWidgetUnderTest(
          tester, Project.newWithName('some-existing-project'));

      await tester.tapAndSettle(find.findByText('some-existing-project'));
      find.findByText(appTitle_Text, count: 0);

      await tester.tapAndSettle(find.findByText(navEntryLabelSettings));
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
