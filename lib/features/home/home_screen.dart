import 'package:storied/config/app_config.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/home/add_story_screen.dart';
import 'package:storied/features/home/story_selection.dart';
import 'package:flutter/material.dart';
import 'package:storied/features/story/story_project_page.dart';

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

  Future<void> _onAddStory(String name) async {
    var project = await widget._appConfig.addProject(name);
    setState(() {
      _projects = widget._appConfig.projects;
    });
    _navigateToStory(project);
  }

  void _addProject() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => AddStory(_onAddStory),
        ));
  }

  void _navigateToStory(project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryProjectPage(project),
      ),
    );
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
            children: [
              SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Storied',
                    style: text.headlineLarge?.apply(
                        color: colors.onPrimary,
                        decorationColor: colors.onPrimary,
                        decoration: TextDecoration.underline),
                    textAlign: TextAlign.center,
                  )),
              StorySelection(_projects, _navigateToStory),
              // ,
            ],
          )),
    );
  }
}
