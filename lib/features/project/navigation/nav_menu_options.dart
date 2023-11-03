import 'package:flutter/material.dart';
import 'package:storied/features/project/document/document_page.dart';
import 'package:storied/features/project/navigation/terms.dart';
import 'package:storied/features/project/settings/settings_screen.dart';

class NavEntry {
  dynamic component;
  String label;
  IconData icon;
  Function onSelect;

  NavEntry(this.component, this.label, this.icon, this.onSelect);
}

class NavMenuOptions {
  late ValueNotifier<int> selected;
  late List<NavEntry> entries;

  NavMenuOptions() {
    entries = List.of([
      NavEntry(const DocumentPage(), navEntryLabelDocument, Icons.edit, select),
      NavEntry(const SettingsScreen(), navEntryLabelSettings, Icons.settings,
          select),
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
