import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:storied/common/exceptions.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/common/storage/app_config_storage.dart';
import 'features/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initGetIt();
  await getIt.getAsync<AppConfigStorage>();

  FlutterError.onError = (details) async {
    FlutterError.presentError(details);
    captureException(
        exception: details.exception,
        stack: details.stack,
        message: 'Unable to delete project');
    if (kReleaseMode) {
      exit(1);
    }
  };

  await SentryFlutter.init((options) {
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1.0;
  }, appRunner: () => runApp(const MyApp()));
}

const text = TextTheme(
  displayLarge: TextStyle(fontFamily: 'Raleway'),
  displayMedium: TextStyle(fontFamily: 'Raleway'),
  displaySmall: TextStyle(fontFamily: 'Raleway'),
  headlineLarge: TextStyle(fontFamily: 'Raleway'),
  headlineMedium: TextStyle(fontFamily: 'Raleway'),
  headlineSmall: TextStyle(fontFamily: 'Raleway'),
);

final lightColors =
    ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.light);
final darkColors =
    ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark);

final lightTheme = ThemeData.from(
    colorScheme: lightColors, textTheme: text, useMaterial3: true);
final darkTheme = ThemeData.from(
    colorScheme: darkColors, textTheme: text, useMaterial3: true);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appName = 'Storied';

    return MaterialApp(
      title: appName,
      darkTheme: darkTheme,
      theme: lightTheme,
      home: const HomeScreen(),
    );
  }
}
