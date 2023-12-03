import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/_test_helpers/find_extensions.dart';
import 'package:storied/_test_helpers/tester_extensions.dart';
import 'package:storied/clients/_mocks/google_apis_mocks.dart';
import 'package:storied/clients/google_apis_provider.dart';
import 'package:storied/clients/local_storage_client.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/domain/document/_mocks/document.dart';
import 'package:storied/domain/project/_mocks/project_storage.dart';
import 'package:storied/domain/project/project.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:storied/features/add_project/add_project_screen.dart';
import 'package:storied/features/add_project/new_project.dart';
import 'package:storied/features/home/home_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/features/home/terms.dart';
import 'package:storied/features/project/project_screen.dart';
import 'package:storied/domain/projects.dart';

const root = 'root/com.app';
const Iterable<Project> emptyProjects = [];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(HomeScreen, () {
    setUp(() async {
      getIt.reset();
      registerFallbackValue(NewProject('dummy', StorageAdapterType.local));
    });

    createWidgetUnderTest(WidgetTester tester,
        {Iterable<Project> projects = emptyProjects,
        bool signIn = false}) async {
      getIt.registerSingleton<LocalStorageClient>(LocalStorageClient());
      getIt.registerSingleton<ProjectStorageAdapterConfig>(
          ProjectStorageAdapterConfig());
      getIt.registerLazySingleton<GoogleApisProvider>(() {
        var googleApis = MockGoogleApisProvider();
        when(() => googleApis.isSignedIn).thenReturn(signIn);
        return googleApis;
      });
      getIt.registerFactory<Projects>(() {
        return Projects(List.of(projects));
      });

      await tester.pumpWidget(const MaterialApp(
        home: HomeScreen(),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('allows navigating to an existing project',
        (WidgetTester tester) async {
      var storage = MockProjectStorage();
      when(() => storage.getDocument())
          .thenAnswer((_) => Future.value(buildDocument()));

      await createWidgetUnderTest(tester, projects: [
        buildProject(name: 'some-project-title', storage: storage)
      ]);

      expect(find.text('some-project-title'), findsOneWidget);

      await tester.tapAndSettle(find.text('some-project-title'));

      find.findByText(appTitle_Text, count: 0);
      find.findByType(ProjectScreen, count: 1);
    });

    testWidgets('allows navigating to create a project',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      await tester.tapAndSettle(find.findByText(createProjectAction_Label));

      find.findByType(AddProjectScreen, count: 1);
    });

    testWidgets('gives the option to link a Google account',
        (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      await createWidgetUnderTest(tester);

      find.findByText(appIntegration_LinkGoogle_Label);
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
