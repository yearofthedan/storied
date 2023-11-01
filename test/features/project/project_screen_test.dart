import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/config/project.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/features/project/project_screen.dart';
import 'package:storied/projects.dart';

import '../../_helpers/find_extensions.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('project', () {
    setUp(() async {
      getIt.reset();
      registerFallbackValue(MaterialPageRoute(
        builder: (context) => Container(),
      ));
    });

    createWidgetUnderTest(WidgetTester tester, Project project) async {
      var mockNavigator = TestObserver();
      await tester.pumpWidget(MaterialApp(
        home: ProjectScreen(project),
      ));
      await tester.pumpAndSettle();
      return mockNavigator;
    }

    testWidgets('displays the menu options', (WidgetTester tester) async {
      await createWidgetUnderTest(
          tester, Project.newWithName('sample project'));
      find.findByText('sample project');
      find.findByText('Document');
      find.findByText('Settings');
      find.findByText('Exit');
    });
  });
}

void expectCurrRoute(TestObserver mockNavigator, name) {
  Route? route = verify(
          () => mockNavigator.didPush(captureAny<MaterialPageRoute>(), any()))
      .captured
      .lastOrNull;

  expect(route == null, false);
}

class FakeProjectStorage extends Mock implements ProjectStorage {
  @override
  Future<void> add(Project project) {
    return Future.value();
  }
}

class TestObserver extends Mock implements NavigatorObserver {}
