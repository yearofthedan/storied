import 'package:flutter/material.dart';
import 'package:storied/features/project/settings/settings_screen.dart';

const routeKey = 'settings';

navToSettings(BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      settings: const RouteSettings(name: routeKey),
      builder: (_) => const SettingsScreen(),
    ),
  );
}
