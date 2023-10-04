import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditorWidget extends StatelessWidget {
  final QuillController _controller;
  final FocusNode _focusNode = FocusNode();

  EditorWidget(this._controller, {super.key});

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
      showLink: false,
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
}
