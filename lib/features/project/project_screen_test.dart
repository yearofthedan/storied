import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/_test_helpers/tester_extensions.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/domain/project.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/features/project/document/document_page.dart';
import 'package:storied/features/project/settings/settings_screen.dart';
import 'package:storied/features/project/project_screen.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(Project, () {
    setUp(() async {
      getIt.reset();
      registerFallbackValue(MaterialPageRoute(
        builder: (context) => Container(),
      ));
    });

    createWidgetUnderTest(WidgetTester tester, Project project) async {
      await tester.pumpWidget(MaterialApp(
        home: ProjectScreen(project),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('renders the title and the document page',
        (WidgetTester tester) async {
      await createWidgetUnderTest(
          tester, Project.newWithName('Some project name'));

      expect(find.text('Some project name'), findsOneWidget);
      expect(find.byType(DocumentPage), findsOneWidget);
    });

    testWidgets('can navigate to the settings screen',
        (WidgetTester tester) async {
      await createWidgetUnderTest(
          tester, Project.newWithName('Some project name'));

      await tester.tapAndSettle(find.byTooltip('Settings'));

      expect(find.byType(SettingsScreen), findsOneWidget);
    });
  });
}
