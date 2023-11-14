import 'package:flutter/material.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/domain/project.dart';
import 'package:storied/features/project/document/document_page.dart';
import 'package:storied/features/project/settings/routes.dart';
import 'package:storied/features/project/terms.dart';

class ProjectScreen extends StatelessWidget with RouteAware {
  final Project _project;

  ProjectScreen(this._project, {super.key}) {
    if (!getIt.hasScope(_project.id)) {
      getIt.pushNewScope(
          init: (c) => c.registerSingleton<Project>(_project),
          scopeName: _project.id);
    }
  }

  @override
  didPopNext() {
    super.didPopNext();
    getIt.popScope();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_project.name),
        leading: const BackButton(),
        actions: [
          IconButton(
              icon: const Icon(Icons.settings),
              tooltip: viewSettingsAction_tooltip,
              onPressed: () => navToSettings(context)),
        ],
      ),
      body: Row(
        children: [
          Expanded(
              child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: DocumentPage(_project.document))),
        ],
      ),
    );
  }
}
