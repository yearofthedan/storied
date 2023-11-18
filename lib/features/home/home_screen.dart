import 'package:storied/domain/project.dart';
import 'package:storied/features/add_project/routes.dart';
import 'package:storied/features/home/google_account_link.dart';
import 'package:storied/features/home/project_list.dart';
import 'package:flutter/material.dart';
import 'package:storied/features/home/terms.dart';
import 'package:storied/features/project/routes.dart';
import 'package:storied/domain/projects.dart';
import 'package:watch_it/watch_it.dart';
import 'package:flutter_color/flutter_color.dart';

class HomeScreen extends StatelessWidget with WatchItMixin {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    var gradientTargetColor = colors.primary.darker(5);
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
                children: [Icon(Icons.add), Text(createProjectAction_Label)],
              )),
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Center(
                      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppTitle(),
                  ProjectList(projectList, navigateToProject),
                ],
              ))),
              const Divider(
                thickness: 1,
                indent: 32,
                endIndent: 32,
              ),
              Container(
                padding: const EdgeInsets.all(32),
                child: const GoogleAccountLink(),
              )
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
          appTitle_Text,
          style: text.headlineLarge?.apply(
              color: colors.onPrimary,
              decorationColor: colors.onPrimary,
              decoration: TextDecoration.underline),
          textAlign: TextAlign.center,
        ));
  }
}
