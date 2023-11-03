import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/_test_helpers/find_extensions.dart';
import 'package:storied/_test_helpers/tester_extensions.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/domain/project.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/features/home/terms.dart';
import 'package:storied/features/project/navigation/terms.dart';
import 'package:storied/main.dart';
import 'package:storied/projects.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('app', () {
    setUp(() async {
      getIt.reset();
    });

    createWidgetUnderTest(WidgetTester tester) async {
      getIt.registerSingleton<ProjectStorage>(FakeProjectStorage());
      getIt.registerFactory<Projects>(() {
        return Projects(List.of([Project.newWithName('sample project')]));
      });
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
    }

    testWidgets('allows opening and closing a project',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);
      find.findByText(appTitleDisplayText);

      await tester.tapAndSettle(find.text('sample project'));
      find.findByText(appTitleDisplayText, count: 0);

      await tester.tapAndSettle(find.text(exitProjectActionLabel));
      find.findByText(appTitleDisplayText);
    });
  });
}

class FakeProjectStorage extends Mock implements ProjectStorage {
  @override
  Future<void> add(Project project) {
    return Future.value();
  }
}

class TestObserver extends Mock implements NavigatorObserver {}
