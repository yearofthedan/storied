import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class EditorWidget extends StatelessWidget {
  final QuillController _controller;
  final FocusNode _focusNode = FocusNode();

  EditorWidget(this._controller, {super.key});

  @override
  Widget build(BuildContext context) {
    var toolbar = QuillToolbar.basic(
      controller: _controller,
      embedButtons: FlutterQuillEmbeds.buttons(
          // provide a callback to enable picking images from device.
          // if omit, "image" button only allows adding images from url.
          // same goes for videos.
          // onImagePickCallback: _onImagePickCallback,
          // onVideoPickCallback: _onVideoPickCallback,
          // uncomment to provide a custom "pick from" dialog.
          // mediaPickSettingSelector: _selectMediaPickSetting,
          // uncomment to provide a custom "pick from" dialog.
          // cameraPickSettingSelector: _selectCameraPickSetting,
          ),
      showAlignmentButtons: true,
      afterButtonPressed: _focusNode.requestFocus,
    );

    return SafeArea(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            // flex: 15,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: _editorPanel(context),
            ),
          ),
          Container(child: toolbar)
        ],
      ),
    );
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
      padding: EdgeInsets.zero,
      // onImagePaste: _onImagePaste,
      // onTapUp: (details, p1) {
      //   return _onTripleClickSelection();
      // },
      customStyles: DefaultStyles(
        h1: DefaultTextBlockStyle(
            const TextStyle(
              fontSize: 32,
              color: Colors.black,
              height: 1.15,
              fontWeight: FontWeight.w300,
            ),
            const VerticalSpacing(16, 0),
            const VerticalSpacing(0, 0),
            null),
        sizeSmall: const TextStyle(fontSize: 9),
        subscript: const TextStyle(
          fontFamily: 'SF-UI-Display',
          fontFeatures: [FontFeature.subscripts()],
        ),
        superscript: const TextStyle(
          fontFamily: 'SF-UI-Display',
          fontFeatures: [FontFeature.superscripts()],
        ),
      ),
      embedBuilders: [
        ...FlutterQuillEmbeds.builders(),
        // TimeStampEmbedBuilderWidget()
      ],
    );
    return quillEditor;
  }
}
