import 'package:flutter/material.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/config/project.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void alertDialog(BuildContext context) {
    var alert = AlertDialog(
      actions: [
        OutlinedButton(onPressed: () {}, child: const Text('Delete')),
        FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Keep'))
      ],
      title: const Text('Delete project?'),
      content: const Text('This cannot be undone!'),
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
            title: const Text('Title'),
            subtitle: Text(project.name),
          ),
          ListTile(
            onTap: () => alertDialog(context),
            title: const Text('Delete'),
            trailing: const Icon(Icons.delete),
          ),
        ],
      ),
    ));
  }
}
