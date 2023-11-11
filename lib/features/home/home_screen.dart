import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as sign_in;
import 'package:logger/logger.dart';
import 'package:storied/common/exceptions.dart';
import 'package:storied/domain/project.dart';
import 'package:storied/features/add_project/routes.dart';
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
              const AppTitle(),
              ProjectList(projectList, navigateToProject),
              Container() // const GoogleLink()
              // ,
            ],
          )),
    );
  }
}

class GoogleLink extends StatelessWidget {
  const GoogleLink({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: _handleSignIn, child: const Text('Click!'));
  }

  Future<void> _handleSignIn() async {
    try {
      final googleSignIn =
          sign_in.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
      final sign_in.GoogleSignInAccount? account = await googleSignIn.signIn();
      Logger().i('User account $account');
    } catch (error, stack) {
      captureException(
          exception: error, stack: stack, message: 'Error trying to sign in');
    }
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
