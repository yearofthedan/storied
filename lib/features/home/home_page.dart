import 'package:storied/config/app_config.dart';
import 'package:storied/features/home/story_selection.dart';
import 'package:flutter/material.dart';
import 'package:storied/storage/local_storage_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppConfig? _configModel;

  @override
  void initState() {
    super.initState();
    _getAppConfig();
  }

  Future<void> _getAppConfig() async {
    AppConfig configModel =
        (await AppConfigFactory.loadConfig(AppStorage(LocalStorageClient())));
    setState(() {
      _configModel = configModel;
    });
  }

  Future<void> _addProject() async {
    var config = await _configModel!.addProject();
    setState(() {
      _configModel = config;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_configModel == null) {
      return Container();
    }

    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _addProject(),
            label: const Row(
              children: [Icon(Icons.add), Text('New')],
            )),
        backgroundColor: Colors.green,
        body: Container(
          padding: const EdgeInsets.all(8),
          child: Center(child: StorySelection(_configModel!.projects)),
        ));
  }
}
