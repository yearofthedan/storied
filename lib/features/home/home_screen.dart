import 'package:storied/config/app_config.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/home/story_selection.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final AppConfig _appConfig;

  const HomeScreen(this._appConfig, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    var colors = Theme.of(context).colorScheme;
    TextTheme text = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            colors.primary,
            Color.fromARGB(
              colors.primary.alpha,
              colors.primary.red,
              colors.primary.green - 30,
              colors.primary.blue,
            )
          ])),
      child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _addProject(),
              label: const Row(
                children: [Icon(Icons.add), Text('New')],
              )),
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Storied',
                    style: text.headlineLarge?.apply(color: colors.onPrimary),
                  )),
              StorySelection(_projects),
              // ,
            ],
          )),
    );
  }
}
