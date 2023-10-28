import 'package:storied/config/app_storage.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/story/document/document_persistence.dart';
import 'package:storied/features/selected_story_state.dart';
import 'package:storied/storage/local_storage_client.dart';
import 'package:storied/widgets/editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:provider/provider.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  QuillController? _controller;
  DocumentPersistence? documentPersistence;

  @override
  void initState() {
    super.initState();
  }

  docOrNew(DocumentPersistence persistence) async {
    try {
      final doc = await persistence.getProjectDocument();
      return doc;
    } catch (error) {
      return Document()..insert(0, 'Empty asset');
    }
  }

  Future<void> _loadFromAssets(String projectId) async {
    AppStorage appStorage = AppStorage(LocalStorageClient());
    documentPersistence = DocumentPersistence(appStorage, projectId);
    Document doc = await docOrNew(documentPersistence!);
    setState(() {
      _controller = QuillController(document: doc, selection: const TextSelection.collapsed(offset: 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    Project project = context.watch<SelectedStoryState>().project;
    if (_controller == null) {
      _loadFromAssets(project.id);
    }

    if (_controller == null) {
      return Container();
    } else {
      return EditorWidget(_controller!, () => documentPersistence!.saveDocument(_controller!.document));
    }
  }
}
