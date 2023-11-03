import 'package:storied/domain/project.dart';
import 'package:storied/features/add_project/routes.dart';
import 'package:storied/features/home/project_list.dart';
import 'package:flutter/material.dart';
import 'package:storied/features/home/terms.dart';
import 'package:storied/features/project/routes.dart';
import 'package:storied/projects.dart';
import 'package:watch_it/watch_it.dart';

class HomeScreen extends StatelessWidget with WatchItMixin {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    var gradientTargetColor = Color.fromARGB(
      colors.primary.alpha,
      colors.primary.red,
      colors.primary.green - 30,
      colors.primary.blue,
    );
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
            gradientTargetColor,
          ])),
      child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
              onPressed: navigateToCreate,
              label: const Row(
                children: [Icon(Icons.add), Text(createProjectActionLabel)],
              )),
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppTitle(),
              ProjectList(projectList, navigateToProject),
              // ,
            ],
          )),
    );
  }
}

class AppTitle extends StatelessWidget {
  const AppTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme text = Theme.of(context).textTheme;
    var colors = Theme.of(context).colorScheme;

    return SizedBox(
        width: double.infinity,
        child: Text(
          appTitleDisplayText,
          style: text.headlineLarge?.apply(
              color: colors.onPrimary,
              decorationColor: colors.onPrimary,
              decoration: TextDecoration.underline),
          textAlign: TextAlign.center,
        ));
  }
}
