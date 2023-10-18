import 'package:storied/config/app_config.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/home/story_selection.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final AppConfig _appConfig;

  const HomePage(this._appConfig, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Project> _projects = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _projects = widget._appConfig.projects;
    });
  }

  Future<void> _addProject() async {
    var config = await widget._appConfig.addProject();
    setState(() {
      _projects = config.projects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _addProject(),
            label: const Row(
              children: [Icon(Icons.add), Text('New')],
            )),
        backgroundColor: Colors.green,
        body: Container(
          padding: const EdgeInsets.all(8),
          child: Center(child: StorySelection(_projects)),
        ));
  }
}
