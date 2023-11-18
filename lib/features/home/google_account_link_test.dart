import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/_test_helpers/find_extensions.dart';
import 'package:storied/clients/_mocks/google_apis_mocks.dart';
import 'package:storied/clients/google_apis_provider.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/features/home/google_account_link.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/features/home/terms.dart';

const root = 'root/com.app';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(GoogleAccountLink, () {
    setUp(() async {
      getIt.reset();
    });

    createWidgetUnderTest(WidgetTester tester, {bool signIn = false}) async {
      var googleApis = MockGoogleApisProvider();

      when(() => googleApis.isSignedIn).thenReturn(signIn);

      getIt.registerSingleton<GoogleApisProvider>(googleApis);

      await tester.pumpWidget(const MaterialApp(
        home: GoogleAccountLink(),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('gives the option to link a Google account',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      find.findByText(appIntegration_LinkGoogle_Label);
    });

    testWidgets('gives the option to unlink a Google account',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester, signIn: true);

      find.findByText(appIntegration_UnlinkGoogle_Label);
    });

    testWidgets('gives no option for macOs (for now)',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester, signIn: true);

      find.findByText(appIntegration_LinkGoogle_Label, count: 0);
      find.findByText(appIntegration_UnlinkGoogle_Label, count: 0);
    }, variant: TargetPlatformVariant.desktop());
  });
}
