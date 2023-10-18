import 'package:storied/widgets/notes/notes_block_embed.dart';
import 'package:storied/widgets/notes/notes_embed_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class EditorWidget extends StatelessWidget {
  final QuillController _controller;
  final FocusNode _focusNode = FocusNode();
  final Function _onSave;

  EditorWidget(this._controller, this._onSave, {super.key});

  @override
  Widget build(BuildContext context) {
    var toolbar = QuillToolbar.basic(
      controller: _controller,
      showAlignmentButtons: true,
      afterButtonPressed: _focusNode.requestFocus,
      showFontSize: false,
      showFontFamily: false,
      showCodeBlock: false,
      showInlineCode: false,
      showListCheck: false,
      showQuote: false,
      showLink: false,
      customButtons: [
        QuillCustomButton(
            icon: Icons.ac_unit,
            onTap: () {
              _addEditNote(context);
            }),
        QuillCustomButton(
            icon: Icons.save,
            onTap: () {
              _onSave();
            }),
      ],
    );

    return SafeArea(
        child: Container(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 800,
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: toolbar,
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: 800,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: _editorPanel(context),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _editorPanel(BuildContext context) {
    Widget quillEditor = QuillEditor(
      controller: _controller,
      embedBuilders: [NotesEmbedBuilder(addEditNote: _addEditNote)],
      scrollController: ScrollController(),
      scrollable: true,
      focusNode: _focusNode,
      autoFocus: false,
      readOnly: false,
      placeholder: 'Add content',
      enableSelectionToolbar: isMobile(),
      expands: true,
      padding: const EdgeInsets.all(16.0),
      maxContentWidth: 600,
    );
    return quillEditor;
  }

  Future<void> _addEditNote(BuildContext context, {Document? document}) async {
    final isEditing = document != null;
    final quillEditorController = QuillController(
      document: document ?? Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: const EdgeInsets.only(left: 16, top: 8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${isEditing ? 'Edit' : 'Add'} note'),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            )
          ],
        ),
        content: QuillEditor.basic(
          controller: quillEditorController,
          readOnly: false,
        ),
      ),
    );

    if (quillEditorController.document.isEmpty()) return;

    final block = BlockEmbed.custom(
      NotesBlockEmbed.fromDocument(quillEditorController.document),
    );
    final controller = _controller;
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;

    if (isEditing) {
      final offset =
          getEmbedNode(controller, controller.selection.start).offset;
      controller.replaceText(
          offset, 1, block, TextSelection.collapsed(offset: offset));
    } else {
      controller.replaceText(index, length, block, null);
    }
  }
}
