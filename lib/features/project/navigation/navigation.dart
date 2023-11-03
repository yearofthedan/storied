import 'package:flutter/material.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/project/navigation/nav_menu.dart';
import 'package:storied/features/project/navigation/nav_menu_options.dart';
import 'package:storied/features/project/navigation/terms.dart';

_returnToHome(BuildContext context) {
  getIt.popScope();
  Navigator.popUntil(context, (route) => route.isFirst);
}

class Navigation extends StatelessWidget {
  final Project _project;

  const Navigation(this._project, {super.key});

  @override
  Widget build(BuildContext context) {
    var navOptions = NavMenuOptions();
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
            child: const Text(exitProjectActionLabel),
          ),
        ),
        body: Row(
          children: [
            SafeArea(
                child: NavMenu(
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
