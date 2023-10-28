import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder findFieldByText(text) {
  var result = find.widgetWithText(TextField, text);
  expect(result, findsOneWidget);
  return result;
}

Finder findByText(text) {
  var result = find.text(text);
  expect(result, findsOneWidget);
  return result;
}
