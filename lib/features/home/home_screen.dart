import 'package:storied/common/get_it.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/home/add_story_screen.dart';
import 'package:storied/features/home/story_selection.dart';
import 'package:flutter/material.dart';
import 'package:storied/features/story/story_project_page.dart';
import 'package:storied/projects.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Projects? _projects;

  @override
  void initState() {
    super.initState();
    getProjects();
  }

  Future<void> getProjects() async {
    var pr = await getIt.getAsync<Projects>();
    setState(() {
      _projects = pr;
    });
  }

  Future<void> _onProjectAdded(String name) async {
    Project project = await _projects!.createProject(name);
    _navigateToStory(project);
  }

  void _addProject() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: 'add-story'),
          fullscreenDialog: true,
          builder: (context) => AddStory(_onProjectAdded),
        ));
  }

  void _navigateToStory(project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: 'view-story'),
        builder: (context) => StoryProjectPage(project),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    TextTheme text = Theme.of(context).textTheme;

    if (_projects == null) {
      return Container();
    }

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
              onPressed: _addProject,
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
              StorySelection(_projects!.projectList, _navigateToStory),
              // ,
            ],
          )),
    );
  }
}
