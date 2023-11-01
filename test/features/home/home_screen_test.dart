import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/common/strings.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/home/home_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/projects.dart';

import '../../_helpers/find_extensions.dart';
import '../../_helpers/tester_extensions.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('home', () {
    setUp(() async {
      getIt.reset();
      registerFallbackValue(MaterialPageRoute(
        builder: (context) => Container(),
      ));
    });

    createWidgetUnderTest(
        WidgetTester tester, Iterable<Project> projects) async {
      getIt.registerSingleton<ProjectStorage>(FakeProjectStorage());
      getIt.registerFactory<Projects>(() {
        return Projects(List.of(projects));
      });

      var mockNavigator = TestObserver();
      await tester.pumpWidget(MaterialApp(
        navigatorObservers: [mockNavigator],
        home: const HomeScreen(),
      ));
      await tester.pumpAndSettle();
      return mockNavigator;
    }

    testWidgets('allows navigating to an existing project',
        (WidgetTester tester) async {
      var mockNavigator = await createWidgetUnderTest(
          tester, [Project.newWithName('my story')]);
      expect(find.text('my story'), findsOneWidget);

      await tester.tap(find.text('my story'));
      await tester.pump();

      expectCurrRoute(mockNavigator, 'open-project');
    });

    testWidgets('supports creating a project', (WidgetTester tester) async {
      var mockNavigator = await createWidgetUnderTest(tester, []);

      await tester.tapAndSettle(find.findByText('New'));
      expectCurrRoute(mockNavigator, 'add-project');

      await tester.enterText(find.findFieldByText('Story name'), 'testing');
      await tester.tapAndSettle(find.findByText(getString('CREATE_STORY')));
      expectCurrRoute(mockNavigator, 'open-project');
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
