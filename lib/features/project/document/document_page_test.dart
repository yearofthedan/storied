import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/domain/document/_mocks/document.dart';
import 'package:storied/domain/document/document.dart';
import 'package:storied/features/project/document/document_page.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(DocumentPage, () {
    createWidgetUnderTest(WidgetTester tester, {Document? document}) async {
      await tester.pumpWidget(MaterialApp(
        home: DocumentPage(document ?? buildDocument()),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('renders an editor for an empty doc',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester, document: buildDocument(data: null));

      find.byType(q.QuillEditor);
      expect(find.byType(DocumentPage), findsOneWidget);
    });

    testWidgets('renders the editor', (WidgetTester tester) async {
      await createWidgetUnderTest(
        tester,
      );

      find.byType(q.QuillEditor);
      expect(find.byType(DocumentPage), findsOneWidget);
    });
  });
}
