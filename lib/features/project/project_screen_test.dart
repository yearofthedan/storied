import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/_test_helpers/find_extensions.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/domain/project.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/features/project/navigation/terms.dart';
import 'package:storied/features/project/project_screen.dart';

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
      find.findByText(navEntryLabelDocument);
      find.findByText(navEntryLabelSettings);
      find.findByText(exitProjectActionLabel);
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

class TestObserver extends Mock implements NavigatorObserver {}
