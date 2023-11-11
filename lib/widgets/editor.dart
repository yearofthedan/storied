import 'package:storied/common/device/responsiveness.dart';
import 'package:storied/widgets/notes/notes_block_embed.dart';
import 'package:storied/widgets/notes/notes_embed_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class EditorToolbar extends StatelessWidget {
  final double toolbarIconSize = 16;

  final QuillController _controller;

  final Function() onAddEditNote;
  final Function() onSaveDocument;

  const EditorToolbar(
    this._controller, {
    super.key,
    required this.onAddEditNote,
    required this.onSaveDocument,
  });

  @override
  Widget build(BuildContext context) {
    return QuillToolbar(
      toolbarIconAlignment: WrapAlignment.start,
      children: [
        HistoryButton(
          icon: Icons.undo_outlined,
          iconSize: toolbarIconSize,
          tooltip: 'undo',
          controller: _controller,
          undo: true,
        ),
        HistoryButton(
          icon: Icons.redo_outlined,
          iconSize: toolbarIconSize,
          tooltip: 'redo',
          controller: _controller,
          undo: false,
        ),
        ToggleStyleButton(
          attribute: Attribute.bold,
          icon: Icons.format_bold,
          iconSize: toolbarIconSize,
          tooltip: 'bold',
          controller: _controller,
        ),
        ToggleStyleButton(
          attribute: Attribute.italic,
          icon: Icons.format_italic,
          iconSize: toolbarIconSize,
          tooltip: 'italic',
          controller: _controller,
        ),
        ToggleStyleButton(
          attribute: Attribute.underline,
          icon: Icons.format_underline,
          iconSize: toolbarIconSize,
          tooltip: 'underline',
          controller: _controller,
        ),
        ToggleStyleButton(
          attribute: Attribute.strikeThrough,
          icon: Icons.format_strikethrough,
          iconSize: toolbarIconSize,
          tooltip: 'strikethrough',
          controller: _controller,
        ),
        ColorButton(
          icon: Icons.color_lens,
          iconSize: toolbarIconSize,
          tooltip: 'text color',
          controller: _controller,
          background: false,
        ),
        ColorButton(
          icon: Icons.format_color_fill,
          iconSize: toolbarIconSize,
          tooltip: 'background color',
          controller: _controller,
          background: true,
        ),
        ClearFormatButton(
          icon: Icons.format_clear,
          iconSize: toolbarIconSize,
          tooltip: 'clear formatting',
          controller: _controller,
        ),
        SelectAlignmentButton(
          controller: _controller,
          tooltips: const {
            ToolbarButtons.leftAlignment: 'left',
            ToolbarButtons.centerAlignment: 'centre',
            ToolbarButtons.rightAlignment: 'right',
            ToolbarButtons.justifyAlignment: 'justify',
          },
          iconSize: toolbarIconSize,
          showLeftAlignment: true,
          showCenterAlignment: true,
          showRightAlignment: true,
          showJustifyAlignment: true,
        ),
        SelectHeaderStyleButton(
          tooltip: 'text style',
          controller: _controller,
          iconSize: toolbarIconSize,
        ),
        ToggleStyleButton(
          attribute: Attribute.ol,
          tooltip: 'ordered list',
          controller: _controller,
          icon: Icons.format_list_numbered,
          iconSize: toolbarIconSize,
        ),
        ToggleStyleButton(
          attribute: Attribute.ul,
          tooltip: 'bulleted list',
          controller: _controller,
          icon: Icons.format_list_bulleted,
          iconSize: toolbarIconSize,
        ),
        ToggleStyleButton(
          attribute: Attribute.blockQuote,
          tooltip: 'block quote',
          controller: _controller,
          icon: Icons.format_quote,
          iconSize: toolbarIconSize,
        ),
        IndentButton(
          icon: Icons.format_indent_increase,
          iconSize: toolbarIconSize,
          tooltip: 'indent',
          controller: _controller,
          isIncrease: true,
        ),
        IndentButton(
          icon: Icons.format_indent_decrease,
          iconSize: toolbarIconSize,
          tooltip: 'outdent',
          controller: _controller,
          isIncrease: false,
        ),
        SearchButton(
          icon: Icons.search,
          iconSize: toolbarIconSize,
          tooltip: 'search',
          controller: _controller,
        ),
        CustomButton(
          onPressed: onAddEditNote,
          icon: Icons.ac_unit,
          tooltip: 'add note',
          iconSize: toolbarIconSize,
        ),
        CustomButton(
          onPressed: onSaveDocument,
          tooltip: 'save',
          icon: Icons.save,
          iconSize: toolbarIconSize,
        ),
      ],
    );
  }
}

class EditorWidget extends StatelessWidget {
  final QuillController _controller;
  final FocusNode _focusNode = FocusNode();
  final Function _onSave;

  EditorWidget(this._controller, this._onSave, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: 800,
      padding: context.responsive(EdgeInsets.zero,
          sm: const EdgeInsets.only(left: 8, right: 8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: EditorToolbar(
              _controller,
              onAddEditNote: () => _addEditNote(context),
              onSaveDocument: () => _onSave(context),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: 800,
              color: Theme.of(context).canvasColor,
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
