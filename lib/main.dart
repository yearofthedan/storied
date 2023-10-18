import 'package:flutter/material.dart';
import 'package:storied/config/app_config.dart';
import 'package:storied/config/app_storage.dart';
import 'package:storied/storage/local_storage_client.dart';
import 'features/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig config =
      await AppConfigFactory.loadConfig(AppStorage(LocalStorageClient()));
  runApp(MyApp(config));
}

class MyApp extends StatelessWidget {
  final AppConfig _appConfig;

  const MyApp(this._appConfig, {super.key});

  @override
  Widget build(BuildContext context) {
    const String appName = 'Storied';

    return MaterialApp(
      title: appName,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: HomePage(_appConfig),
    );
  }
}
