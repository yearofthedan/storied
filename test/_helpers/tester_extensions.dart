import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExtension on WidgetTester {
  Future<void> tapAndSettle(Finder tappable) async {
    await tap(tappable);
    await pumpAndSettle();
  }
}
