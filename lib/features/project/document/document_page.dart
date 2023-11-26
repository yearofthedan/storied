import 'package:storied/domain/document/document.dart';
import 'package:storied/widgets/editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;

class DocumentPage extends StatelessWidget {
  final Document _document;

  const DocumentPage(this._document, {super.key});

  q.Document _buildQuillDocument() {
    if (_document.empty) {
      return q.Document();
    } else {
      return q.Document.fromJson(_document.data!);
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = q.QuillController(
        document: _buildQuillDocument(),
        selection: const TextSelection.collapsed(offset: 0));

    return q.QuillProvider(
        configurations: q.QuillConfigurations(
          controller: controller,
        ),
        child: EditorWidget(onSave: (q.Document document) {
          _document.data = document.toDelta().toJson();
          _document.save();
        }));
  }
}
