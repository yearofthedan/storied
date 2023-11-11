import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/common/device/responsiveness.dart';

void main() {
  const defaultValue = 'default';
  const smValue = 'small';
  const mdValue = 'medium';
  const lgValue = 'large';
  const xlValue = 'extra large';

  final widget = MaterialApp(
    home: Builder(builder: (context) {
      var text = context.responsive(
        defaultValue,
        sm: smValue,
        md: mdValue,
        lg: lgValue,
        xl: xlValue,
      );

      return Text(text);
    }),
  );

  group('responsive', () {
    testWidgets(
        'Responsive extension returns default value for smallest screen size',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(639, 800);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(widget);
      expect(find.text(defaultValue), findsOneWidget);
    });

    testWidgets('Responsive extension returns correct value for small screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(640, 800);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(widget);
      expect(find.text(smValue), findsOneWidget);
    });

    testWidgets('Responsive extension returns correct value for medium screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(768, 800);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(widget);
      expect(find.text(mdValue), findsOneWidget);
    });

    testWidgets('Responsive extension returns correct value for large screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1024, 800);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(widget);
      expect(find.text(lgValue), findsOneWidget);
    });

    testWidgets(
        'Responsive extension returns correct value for extra large screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(widget);
      expect(find.text(xlValue), findsOneWidget);
    });
  });
}
