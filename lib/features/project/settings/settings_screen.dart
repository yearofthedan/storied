import 'package:flutter/material.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/domain/project.dart';
import 'package:storied/features/project/settings/terms.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void alertDialog(BuildContext context, Project project) {
    var alert = AlertDialog(
      actions: [
        OutlinedButton(
            onPressed: () {
              project.delete().then((value) {
                if (value.deleted) {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                  SnackBarBuilder.success(
                      context, deleteProjectAction_SuccessText);
                } else {
                  SnackBarBuilder.error(
                      context, deleteProjectAction_FailureText);
                }
              });
            },
            child: const Text(deleteProjectConfirmation_ConfirmLabel)),
        FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(deleteProjectConfirmation_CancelLabel))
      ],
      title: const Text(deleteProjectConfirmation_Title),
      content: const Text(deleteProjectConfirmation_InfoText),
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  @override
  Widget build(BuildContext context) {
    Project project = getIt<Project>();
    return Scaffold(
        body: Center(
      child: ListView(
        children: [
          ListTile(
            title: const Text(settingEntry_TitleLabel),
            subtitle: Text(project.name),
          ),
          ListTile(
            title: const Text(settingEntry_PathLabel),
            subtitle: Text(project.path ?? 'Unknown path'),
          ),
          ListTile(
            onTap: () => alertDialog(context, project),
            title: const Text(deleteProjectAction_Label),
            trailing: const Icon(Icons.delete),
          ),
        ],
      ),
    ));
  }
}

class SnackBarBuilder {
  static error(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      showCloseIcon: true,
      backgroundColor: Colors.red,
    ));
  }

  static success(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      showCloseIcon: true,
      backgroundColor: Colors.green,
    ));
  }
}
