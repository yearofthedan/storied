import 'package:flutter_test/flutter_test.dart';

Future<void> tapAndSettle(WidgetTester tester, Finder newButton) async {
  await tester.tap(newButton);
  await tester.pumpAndSettle();
}
