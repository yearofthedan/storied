import 'package:storied/common/get_it.dart';
import 'package:storied/config/app_storage.dart';
import 'package:storied/config/project.dart';
import 'package:storied/features/project/document/document_persistence.dart';
import 'package:storied/common/storage/local_storage_client.dart';
import 'package:storied/widgets/editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class DocumentPage extends StatefulWidget {
  const DocumentPage({super.key});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  QuillController? _controller;
  DocumentPersistence? documentPersistence;

  docOrNew(DocumentPersistence persistence) async {
    try {
      final doc = await persistence.getProjectDocument();
      return doc;
    } catch (error) {
      return Document()..insert(0, 'Empty asset');
    }
  }

  Future<void> _loadFromAssets(String projectId) async {
    AppConfig appStorage = AppConfig(LocalStorageClient());
    documentPersistence = DocumentPersistence(appStorage, projectId);
    Document doc = await docOrNew(documentPersistence!);
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
    }

    if (_controller == null) {
      return Container();
    } else {
      return EditorWidget(_controller!,
          () => documentPersistence!.saveDocument(_controller!.document));
    }
  }
}
