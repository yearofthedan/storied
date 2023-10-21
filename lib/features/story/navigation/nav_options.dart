import 'package:flutter/material.dart';

class NavEntry {
  dynamic component;
  String label;
  IconData icon;
  Function onSelect;

  NavEntry(this.component, this.label, this.icon, this.onSelect);
}
