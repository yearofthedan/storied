import 'package:storied/common/get_it.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/home/add_project_screen.dart';
import 'package:storied/features/home/project_list.dart';
import 'package:flutter/material.dart';
import 'package:storied/features/project/project_screen.dart';
import 'package:storied/projects.dart';
import 'package:watch_it/watch_it.dart';

navToProject(BuildContext context, Project project) {
  getIt<Projects>().setActive(project);
  Navigator.push(
    context,
    MaterialPageRoute(
      settings: const RouteSettings(name: 'open-project'),
      builder: (_) => ProjectScreen(project),
    ),
  );
}

navToAddProject(BuildContext context, Function(Project) onAdded) {
  Navigator.push(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: 'add-project'),
        fullscreenDialog: true,
        builder: (_) => AddProjectScreen(onAdded),
      ));
}

class HomeScreen extends StatelessWidget with WatchItMixin {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    TextTheme text = Theme.of(context).textTheme;
    final List<Project> projectList =
        watchPropertyValue<Projects, List<Project>>((p) => p.projectList);

    navigateToProject(Project project) => navToProject(context, project);
    navigateToCreate() => navToAddProject(context, navigateToProject);

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
              onPressed: navigateToCreate,
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
              ProjectList(projectList, navigateToProject),
              // ,
            ],
          )),
    );
  }
}
