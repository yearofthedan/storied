import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:storied/common/strings.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/home/home_screen.dart';
import 'package:storied/features/selected_story_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/projects.dart';

import '../../_helpers/findExtensions.dart';
import '../../_helpers/testerExtensions.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('home', () {
    setUp(() async {
      registerFallbackValue(MaterialPageRoute(
        builder: (context) => Container(),
      ));
    });

    createWidgetUnderTest(WidgetTester tester, Iterable<Project> projects) async {
      var mockNavigator = TestObserver();
      var fakeProjectStorage = FakeProjectStorage();
      when(() => fakeProjectStorage.getAll())
          .thenAnswer((_) => Future.value(List.of(projects)));

      await tester.pumpWidget(MaterialApp(
          navigatorObservers: [mockNavigator],
          home: ChangeNotifierProvider(
            create: (context) =>
                SelectedStoryState(Project.newWithName('placeholder')),
            child: HomeScreen(fakeProjectStorage),
          )));
      await tester.pumpAndSettle();
      return mockNavigator;
    }

    testWidgets('allows navigating to an existing project',
        (WidgetTester tester) async {
      var mockNavigator =
          await createWidgetUnderTest(tester, [Project.newWithName('my story')]);
      expect(find.text('my story'), findsOneWidget);

      await tester.tap(find.text('my story'));
      await tester.pump();

      expectCurrRoute(mockNavigator, 'view-story');
    });

    testWidgets('supports creating a project', (WidgetTester tester) async {
      var mockNavigator = await createWidgetUnderTest(tester, []);

      await tapAndSettle(tester, findByText('New'));
      expectCurrRoute(mockNavigator, 'add-story');

      await tester.enterText(findFieldByText('Story name'), 'testing');
      await tapAndSettle(tester, findByText(getString('CREATE_STORY')));
      expectCurrRoute(mockNavigator, 'view-story');
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
