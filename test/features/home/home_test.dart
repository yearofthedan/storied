import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:storied/config/app_config.dart';
import 'package:storied/features/home/home_page.dart';
import 'package:storied/features/selected_story_state.dart';

import '../../_helpers/storage.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('home', () {
    setUp(() async {
      PathProviderPlatform.instance = FakePathProviderPlatform(root);
    });
    testWidgets('shows an entry for each project', (WidgetTester tester) async {
      IOOverrides.runZoned(() async {
        await tester.pumpWidget(MaterialApp(
            home: ChangeNotifierProvider(
          create: (context) => SelectedStoryState(Project.fromName('my story')),
          child: const HomePage(),
        )));
        await tester.pumpAndSettle();

        expect(find.text('my story'), findsOneWidget);

        await tester.tap(find.text('my story'));
        await tester.pump();
      },
          createFile: (path) =>
              FakeFile('{ "projects": [{ "name": "my story" }] }'));
    });
  });
}

class FakeFile extends Fake implements File {
  final String _content;

  FakeFile(this._content);

  @override
  bool existsSync() {
    return true;
  }

  @override
  Future<String> readAsString({Encoding encoding = utf8}) {
    return Future.value(_content);
  }
}
