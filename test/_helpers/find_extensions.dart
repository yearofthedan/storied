import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension CommonFindersExtension on CommonFinders {
  Finder findByText(searchText) {
    var result = text(searchText);
    expect(result, findsOneWidget);
    return result;
  }

  Finder findFieldByText(text) {
    var result = widgetWithText(TextField, text);
    expect(result, findsOneWidget);
    return result;
  }
}
