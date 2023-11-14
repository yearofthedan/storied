import 'package:storied/common/get_it.dart';
import 'package:storied/domain/project.dart';
import 'package:storied/features/project/document/content.dart';
import 'package:storied/widgets/editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class DocumentPage extends StatefulWidget {
  final Content<dynamic> _content;

  const DocumentPage(this._content, {super.key});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  QuillController? _controller;

  docOrNew() async {
    try {
      return Document.fromJson(await widget._content.load());
    } catch (error) {
      return Document()..insert(0, 'Empty asset');
    }
  }

  Future<void> _loadFromAssets(String projectId) async {
    Document doc = await docOrNew();
    setState(() {
      _controller = QuillController(
          document: doc, selection: const TextSelection.collapsed(offset: 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    Project project = getIt<Project>();

    if (_controller == null) {
      _loadFromAssets(project.id);
      return Container();
    }

    return QuillProvider(
        configurations: QuillConfigurations(
          controller: _controller!,
        ),
        child: EditorWidget((Document document) =>
            widget._content.save(document.toDelta().toJson())));
  }
}
