import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/_test_helpers/find_extensions.dart';
import 'package:storied/_test_helpers/mocktail.dart';
import 'package:storied/_test_helpers/tester_extensions.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/domain/_mocks/project_storage.dart';
import 'package:storied/domain/project.dart';
import 'package:storied/domain/project_storage.dart';
import 'package:storied/features/add_project/add_project_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/features/add_project/terms.dart';
import 'package:storied/domain/projects.dart';

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
      var storage = MockProjectStorage();
      when(() => storage.add(any())).thenAnswer(reflectFirstArgAsFuture);

      getIt.registerSingleton<ProjectStorage>(storage);
      getIt.registerFactory<Projects>(() {
        return Projects([]);
      });

      onAdded(Project project) => {added = project};

      await tester.pumpWidget(MaterialApp(
        home: AddProjectScreen(onAdded),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('allows adding a project', (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      var field = find.findWidgetWithText(projectNameField_Label);
      await tester.enterText(field, 'my project');

      await tester
          .tapAndSettle(find.findByText(submitCreateProjectAction_Label));

      expect(added?.name, 'my project');
    });
  });
}
