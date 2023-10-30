import 'dart:math';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/common/strings.dart';
import 'package:storied/common/responsiveness.dart';
import 'package:storied/common/spacing.dart';
import 'package:storied/config/project.dart';
import 'package:storied/projects.dart';

class AddProjectScreen extends StatelessWidget {
  final Function(Project) _onAdded;

  const AddProjectScreen(this._onAdded, {super.key});

  _genTitle() {
    return '${nouns.elementAt(Random().nextInt(50))} ${nouns.elementAt(Random().nextInt(50))}';
  }

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController(text: _genTitle());

    onSubmit(String value) async {
      Project project = await getIt<Projects>().createProject(value);
      _onAdded(project);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SizedBox.expand(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ResponsiveTextField(
                  onSubmit: onSubmit,
                  label: 'Story name',
                  controller: controller),
              SizedBox(height: spacing['2']),
              ResponsiveFilledButton(
                  label: getString('CREATE_STORY'),
                  onSubmit: onSubmit,
                  controller: controller)
            ]),
      ),
    );
  }
}

class ResponsiveFilledButton extends StatelessWidget {
  const ResponsiveFilledButton({
    super.key,
    required this.label,
    required this.onSubmit,
    required this.controller,
  });

  final Function(String p1) onSubmit;
  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        onPressed: () => onSubmit(controller.text), child: Text(label));
  }
}

class ResponsiveTextField extends StatelessWidget {
  const ResponsiveTextField({
    super.key,
    required this.label,
    required this.onSubmit,
    required this.controller,
  });

  final Function(String p1) onSubmit;
  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: context.responsive(300, sm: 400),
      ),
      child: TextField(
        onSubmitted: onSubmit,
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}
