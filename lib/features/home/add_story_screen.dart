import 'dart:math';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:storied/common/strings.dart';
import 'package:storied/common/responsiveness.dart';
import 'package:storied/common/spacing.dart';

class AddStory extends StatelessWidget {
  final Function(String) _onAddStory;

  const AddStory(this._onAddStory, {super.key});

  _genTitle() {
    return '${nouns.elementAt(Random().nextInt(50))} ${nouns.elementAt(Random().nextInt(50))}';
  }

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController(text: _genTitle());

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
                  onSubmit: _onAddStory,
                  label: 'Story name',
                  controller: controller),
              SizedBox(height: spacing['2']),
              ResponsiveFilledButton(
                  label: getString('CREATE_STORY'),
                  onSubmit: _onAddStory,
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
