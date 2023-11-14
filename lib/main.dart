import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:storied/common/exceptions.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/common/storage/app_config_storage.dart';
import 'package:storied/common/styling/theme.dart';
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
        message: 'Unhandled app error');
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appName = 'Storied';

    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      var theme =
          ThemeConfig.fromDeviceSchemes(lightColorScheme, darkColorScheme);

      return MaterialApp(
        title: appName,
        darkTheme: theme.dark,
        theme: theme.light,
        home: const HomeScreen(),
      );
    });
  }
}
