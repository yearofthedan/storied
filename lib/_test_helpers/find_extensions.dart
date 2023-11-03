import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension CommonFindersExtension on CommonFinders {
  Finder findByText(searchText, {count = 1}) {
    var result = text(searchText);
    expect(result, findsNWidgets(count));
    return result;
  }

  Finder findWidgetByText(text, {type = TextField}) {
    var result = widgetWithText(type, text);
    expect(result, findsOneWidget);
    return result;
  }
}
