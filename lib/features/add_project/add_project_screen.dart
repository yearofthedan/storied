import 'dart:math';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/common/styling/spacing.dart';
import 'package:storied/domain/project/project.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:storied/domain/projects.dart';
import 'package:storied/features/add_project/responsive_filled_button.dart';
import 'package:storied/features/add_project/responsive_text_field.dart';
import 'package:storied/common/i18n/strings.g.dart';

class AddProjectScreen extends StatefulWidget {
  final Function(Project) _onAdded;

  const AddProjectScreen(this._onAdded, {super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

_genName() {
  return '${nouns.elementAt(Random().nextInt(50))} ${nouns.elementAt(Random().nextInt(50))}';
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  String name = _genName();
  StorageAdapterType storageType = StorageAdapterType.local;

  @override
  Widget build(BuildContext context) {
    var storageOptions = getIt<ProjectStorageAdapterConfig>().enabledStorage;

    var controller = TextEditingController(text: name);

    onSubmit(_) async {
      var project = await getIt<Projects>().createProject(name, storageType);
      widget._onAdded(project);
    }

    return Scaffold(
      appBar: AppBar(),
      body: SizedBox.expand(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ResponsiveTextField(
                  onChange: onProjectNameChange,
                  onSubmit: onSubmit,
                  label: t.addProject.projectNameFieldLabel,
                  controller: controller),
              SizedBox(height: spacing['2']),
              SegmentedButton(
                selected: const {StorageAdapterType.local},
                onSelectionChanged: (selected) {
                  onStorageChange(selected.isEmpty
                      ? StorageAdapterType.local
                      : selected.first);
                },
                segments: [
                  ButtonSegment(
                      value: StorageAdapterType.local,
                      label: Text(t.addProject.storageField.localOptionLabel),
                      icon: const Icon(Icons.folder)),
                  if (storageOptions.contains(StorageAdapterType.gdrive))
                    ButtonSegment(
                        value: StorageAdapterType.gdrive,
                        label:
                            Text(t.addProject.storageField.gDriveOptionLabel),
                        icon: const Icon(Icons.cloud_upload)),
                ],
              ),
              SizedBox(height: spacing['4']),
              ResponsiveFilledButton(
                  label: t.common.createAction,
                  onSubmit: onSubmit,
                  controller: controller)
            ]),
      ),
    );
  }

  onProjectNameChange(String newName) {
    setState(() {
      name = newName;
    });
  }

  onStorageChange(StorageAdapterType newClientType) {
    setState(() {
      storageType = newClientType;
    });
  }
}
