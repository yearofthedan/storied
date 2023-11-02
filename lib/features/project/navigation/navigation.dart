import 'package:flutter/material.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/project/navigation/nav_menu.dart';
import 'package:storied/features/project/navigation/nav_options.dart';

class Navigation extends StatelessWidget {
  final Project _project;

  const Navigation(this._project, {super.key});

  _returnToHome(BuildContext context) {
    getIt.popScope();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    var navOptions = NavOptions();
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          title: Text(_project.name),
          leadingWidth: 80,
          leading: TextButton(
            onPressed: () {
              _returnToHome(context);
            },
            child: const Text('Exit'),
          ),
        ),
        body: Row(
          children: [
            SafeArea(
                child: NavMenu(
              header: CurrentProjectHeader(_project),
              navOptions: navOptions,
            )),
            Expanded(
                child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: ValueListenableBuilder<int>(
                valueListenable: navOptions.selected,
                builder: (BuildContext context, int value, child) {
                  return navOptions.getOption(value).component;
                },
              ),
            ))
          ],
        ),
      );
    });
  }
}

class CurrentProjectHeader extends StatelessWidget {
  final Project _project;

  const CurrentProjectHeader(this._project, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(_project.name);
  }
}
