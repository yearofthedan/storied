import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension CommonFindersExtension on CommonFinders {
  Finder findByText(searchText, {count = 1}) {
    var result = text(searchText);
    expect(result, findsNWidgets(count));
    return result;
  }

  Finder findWidgetWithText(text, {type = TextField}) {
    var result = widgetWithText(type, text);
    expect(result, findsOneWidget);
    return result;
  }

  ScopedFinder within(Finder finder) => ScopedFinder(finder);
}

class ScopedFinder {
  final Finder parentScope;

  const ScopedFinder(this.parentScope);

  findByText(String text) {
    return find.descendant(of: parentScope, matching: find.text(text));
  }
}
