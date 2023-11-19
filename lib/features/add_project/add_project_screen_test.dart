import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/_test_helpers/find_extensions.dart';
import 'package:storied/_test_helpers/tester_extensions.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/domain/_mocks/project_storage.dart';
import 'package:storied/domain/project.dart';
import 'package:storied/domain/project_storage.dart';
import 'package:storied/features/add_project/add_project_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/domain/projects.dart';
import 'package:storied/i18n/strings.g.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(AddProjectScreen, () {
    Project? added;

    setUp(() async {
      getIt.reset();
      registerFallbackValue(Project.newWithName('dummy'));
    });

    createWidgetUnderTest(WidgetTester tester) async {
      getIt.registerFactory<Projects>(() {
        return Projects([]);
      });

      onAdded(Project project) => {added = project};

      await tester.pumpWidget(MaterialApp(
        home: AddProjectScreen(onAdded),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('allows adding a local project', (WidgetTester tester) async {
      var storage = MockProjectStorage();
      when(() => storage.add('my project'))
          .thenAnswer((_) => Future.value(Project.newWithName('my project')));

      getIt.registerSingleton<ProjectStorage>(storage);

      await createWidgetUnderTest(tester);

      var field = find.findWidgetWithText(t.addProject.projectNameFieldLabel);
      await tester.enterText(field, 'my project');

      await tester.tapAndSettle(find.findByText(t.common.createAction));

      // await tester.tapAndSettle(find.findByText(submitAddProjectAction_Label));

      expect(added?.name, 'my project');
    });
  });
}
