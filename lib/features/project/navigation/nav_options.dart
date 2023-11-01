import 'package:flutter/material.dart';
import 'package:storied/features/project/document/document_page.dart';

class NavEntry {
  dynamic component;
  String label;
  IconData icon;
  Function onSelect;

  NavEntry(this.component, this.label, this.icon, this.onSelect);
}

class NavOptions {
  late ValueNotifier<int> selected;
  late List<NavEntry> entries;

  NavOptions() {
    entries = List.of([
      NavEntry(const DocumentPage(), 'Document', Icons.edit, select),
      NavEntry(const DocumentPage(), 'Settings', Icons.settings, select),
    ]);
    selected = ValueNotifier(0);
  }

  select(int index) {
    selected.value = index;
  }

  NavEntry getOption(int index) {
    return entries[index];
  }
}
