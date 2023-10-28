import 'package:storied/widgets/notes/notes_block_embed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class NotesEmbedBuilder extends EmbedBuilder {
  NotesEmbedBuilder({required this.addEditNote});

  Future<void> Function(BuildContext context, {Document? document}) addEditNote;

  @override
  String get key => 'notes';

  @override
  Widget build(
      BuildContext context, QuillController controller, Embed node, bool readOnly, bool inline, TextStyle textStyle) {
    final notes = NotesBlockEmbed(node.value.data).document;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: Container(height: 2, color: Colors.black26)),
        Container(
            transform: Matrix4.translationValues(10.0, 0.0, 0.0),
            child: MouseRegion(
                cursor: MaterialStateMouseCursor.clickable,
                child: Tooltip(
                    message: notes.toPlainText(),
                    child: GestureDetector(
                      onTap: () => addEditNote(context, document: notes),
                      child: const Icon(
                        Icons.note,
                        color: Colors.blue,
                      ),
                    ))))
      ],
    );
  }
}
