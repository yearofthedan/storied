import 'package:flutter/material.dart';
import 'package:storied/config/app_storage.dart';
import 'package:storied/projects.dart';
import 'package:storied/storage/local_storage_client.dart';
import 'features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppStorage appStorage = AppStorage(LocalStorageClient());

  await appStorage.warm();
  runApp(MyApp(appStorage));
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
  final AppStorage _appStorage;

  const MyApp(this._appStorage, {super.key});

  @override
  Widget build(BuildContext context) {
    const String appName = 'Storied';

    return MaterialApp(
      title: appName,
      darkTheme: darkTheme,
      theme: lightTheme,
      home: HomeScreen(ProjectStorage(_appStorage)),
    );
  }
}
