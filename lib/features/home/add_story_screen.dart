import 'dart:math';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class AddStory extends StatelessWidget {
  final Function(String) _onAddStory;

  const AddStory(this._onAddStory, {super.key});

  _genTitle() {
    return '${nouns.elementAt(Random().nextInt(50))} ${nouns.elementAt(Random().nextInt(50))}';
  }

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController(text: _genTitle());

    return Dialog.fullscreen(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onSubmitted: _onAddStory,
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Story name',
              ),
            ),
            FilledButton(
                onPressed: () => _onAddStory(controller.text),
                child: const Text('Add'))
          ]),
    );
  }
}
