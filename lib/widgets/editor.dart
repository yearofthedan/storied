import 'package:storied/common/device/responsiveness.dart';
import 'package:storied/widgets/notes/notes_block_embed.dart';
import 'package:storied/widgets/notes/notes_embed_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditorToolbar extends StatelessWidget {
  final double toolbarIconSize = 16.0;

  final Function() onAddEditNote;
  final Function() onSaveDocument;

  const EditorToolbar({
    super.key,
    required this.onAddEditNote,
    required this.onSaveDocument,
  });

  @override
  Widget build(BuildContext context) {
    return QuillToolbarProvider(
        toolbarConfigurations: const QuillToolbarConfigurations(),
        child: QuillBaseToolbar(
            configurations: QuillBaseToolbarConfigurations(
                toolbarIconAlignment: WrapAlignment.start,
                multiRowsDisplay: false,
                childrenBuilder: (context) {
                  final controller = context.requireQuillController;
                  return [
                    QuillToolbarHistoryButton(
                      controller: controller,
                      options: QuillToolbarHistoryButtonOptions(
                        iconData: Icons.undo_outlined,
                        iconSize: toolbarIconSize,
                        tooltip: 'undo',
                        isUndo: true,
                      ),
                    ),
                    QuillToolbarHistoryButton(
                      controller: controller,
                      options: QuillToolbarHistoryButtonOptions(
                        iconData: Icons.redo_outlined,
                        iconSize: toolbarIconSize,
                        tooltip: 'redo',
                        isUndo: false,
                      ),
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: controller,
                      attribute: Attribute.bold,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconData: Icons.format_bold,
                        iconSize: toolbarIconSize,
                        tooltip: 'bold',
                      ),
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: controller,
                      attribute: Attribute.italic,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconData: Icons.format_italic,
                        iconSize: toolbarIconSize,
                        tooltip: 'italic',
                      ),
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: controller,
                      attribute: Attribute.underline,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconData: Icons.format_underline,
                        iconSize: toolbarIconSize,
                        tooltip: 'underline',
                      ),
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: controller,
                      attribute: Attribute.strikeThrough,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconData: Icons.format_strikethrough,
                        iconSize: toolbarIconSize,
                        tooltip: 'strikethrough',
                      ),
                    ),
                    QuillToolbarClearFormatButton(
                        controller: controller,
                        options: QuillToolbarClearFormatButtonOptions(
                          iconData: Icons.format_clear,
                          iconSize: toolbarIconSize,
                          tooltip: 'clear formatting',
                        )),
                    QuillToolbarColorButton(
                      controller: controller,
                      isBackground: false,
                      options: QuillToolbarColorButtonOptions(
                        iconData: Icons.color_lens,
                        iconSize: toolbarIconSize,
                        tooltip: 'text color',
                      ),
                    ),
                    QuillToolbarColorButton(
                      controller: controller,
                      isBackground: true,
                      options: QuillToolbarColorButtonOptions(
                        iconData: Icons.format_color_fill,
                        iconSize: toolbarIconSize,
                        tooltip: 'background color',
                      ),
                    ),
                    QuillToolbarSelectAlignmentButton(
                        controller: controller,
                        showLeftAlignment: true,
                        showRightAlignment: true,
                        showCenterAlignment: true,
                        showJustifyAlignment: true,
                        options: QuillToolbarSelectAlignmentButtonOptions(
                          iconSize: toolbarIconSize,
                          tooltips: const QuillSelectAlignmentValues(
                              leftAlignment: 'left',
                              centerAlignment: 'centre',
                              rightAlignment: 'right',
                              justifyAlignment: 'justify'),
                        )),
                    QuillToolbarSelectHeaderStyleButtons(
                        controller: controller,
                        options: QuillToolbarSelectHeaderStyleButtonsOptions(
                          tooltip: 'text style',
                          iconSize: toolbarIconSize,
                        )),
                    QuillToolbarToggleStyleButton(
                      controller: controller,
                      attribute: Attribute.ol,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconSize: toolbarIconSize,
                        tooltip: 'ordered list',
                        iconData: Icons.format_list_numbered,
                      ),
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: controller,
                      attribute: Attribute.ul,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconSize: toolbarIconSize,
                        tooltip: 'bulleted list',
                        iconData: Icons.format_list_bulleted,
                      ),
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: controller,
                      attribute: Attribute.blockQuote,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconSize: toolbarIconSize,
                        tooltip: 'block quote',
                        iconData: Icons.format_quote,
                      ),
                    ),
                    QuillToolbarIndentButton(
                        controller: controller,
                        isIncrease: true,
                        options: const QuillToolbarIndentButtonOptions(
                          iconData: Icons.format_indent_increase,
                          tooltip: 'indent',
                          iconSize: 16.0,
                        )),
                    QuillToolbarIndentButton(
                      controller: controller,
                      isIncrease: false,
                      options: const QuillToolbarIndentButtonOptions(
                        iconData: Icons.format_indent_decrease,
                        iconSize: 16.0,
                        tooltip: 'outdent',
                      ),
                    ),
                    QuillToolbarSearchButton(
                      controller: controller,
                      options: QuillToolbarSearchButtonOptions(
                        iconData: Icons.search,
                        iconSize: toolbarIconSize,
                        tooltip: 'search',
                      ),
                    ),
                    QuillToolbarCustomButton(
                        options: QuillToolbarCustomButtonOptions(
                          onPressed: onAddEditNote,
                          icon: const Icon(Icons.ac_unit),
                          tooltip: 'add note',
                          iconSize: toolbarIconSize,
                        ),
                        controller: controller),
                    QuillToolbarCustomButton(
                        options: QuillToolbarCustomButtonOptions(
                          onPressed: onSaveDocument,
                          tooltip: 'save',
                          icon: const Icon(Icons.save),
                          iconSize: toolbarIconSize,
                        ),
                        controller: controller),
                  ];
                })));
  }
}

class EditorWidget extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();
  final Function _onSave;

  EditorWidget(this._onSave, {super.key});

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
        focusNode: _focusNode,
        scrollController: ScrollController(),
        configurations: QuillEditorConfigurations(
          embedBuilders: [NotesEmbedBuilder(addEditNote: _addEditNote)],
          scrollable: true,
          autoFocus: false,
          readOnly: false,
          placeholder: 'Add content',
          enableSelectionToolbar: isMobile(supportWeb: false),
          expands: true,
          padding: const EdgeInsets.all(16.0),
          maxContentWidth: 600,
        ));
    return quillEditor;
  }

  Future<void> _addEditNote(BuildContext context, {Document? document}) async {
    final controller = context.quilController!;
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
          content: QuillProvider(
              configurations: QuillConfigurations(
                controller: quillEditorController,
              ),
              child: QuillEditor.basic())),
    );

    if (quillEditorController.document.isEmpty()) return;

    final block = BlockEmbed.custom(
      NotesBlockEmbed.fromDocument(quillEditorController.document),
    );
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
