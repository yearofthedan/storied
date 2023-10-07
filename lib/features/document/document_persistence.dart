import 'dart:io';

import 'package:bibi/features/local_storage.dart';
import 'package:flutter_quill/flutter_quill.dart';

class DocumentPersistence {
  String documentName;
  LocalStorage storage;

  DocumentPersistence(this.storage, this.documentName);

  Future<Document> get document async {
    if (!(await storage.exists(documentName))) {
      await storage.writeJson(documentName, r'[{"insert":"hello\n"}]');
    }

    return Document.fromJson(await storage.getJson(documentName));
  }

  Future<File> saveDocument(Document document) async {
    return storage.writeJson(documentName, document.toDelta().toJson());
  }
}
