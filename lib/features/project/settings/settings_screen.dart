import 'package:flutter/material.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/project/settings/terms.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void alertDialog(BuildContext context) {
    var alert = AlertDialog(
      actions: [
        OutlinedButton(
            onPressed: () {},
            child: const Text(deleteProjectConfirmActionLabel)),
        FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(deleteProjectCancelActionLabel))
      ],
      title: const Text(deleteProjectAlertTitle),
      content: const Text(deleteProjectAlertHelper),
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
            title: const Text(settingLabelTitle),
            subtitle: Text(project.name),
          ),
          ListTile(
            onTap: () => alertDialog(context),
            title: const Text(deleteProjectActionLabel),
            trailing: const Icon(Icons.delete),
          ),
        ],
      ),
    ));
  }
}
