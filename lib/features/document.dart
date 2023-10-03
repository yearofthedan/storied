import 'package:bibi/widgets/editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  QuillController? _controller;

  @override
  void initState() {
    super.initState();
    _loadFromAssets();
  }

  Future<void> _loadFromAssets() async {
    final doc = Document()..insert(0, 'Empty asset');

    setState(() {
      _controller = QuillController(
          document: doc, selection: const TextSelection.collapsed(offset: 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Container();
    } else {
      return EditorWidget(_controller!);
    }
  }
}
