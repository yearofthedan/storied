import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

extension CommonFindersExtension on CommonFinders {
  Finder findByText(searchText, {count = 1}) {
    var result = text(searchText);
    expect(result, findsNWidgets(count));
    return result;
  }

  Finder findFieldByText(text) {
    var result = widgetWithText(TextField, text);
    expect(result, findsOneWidget);
    return result;
  }
}
