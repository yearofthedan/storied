import 'dart:io';

import 'package:storied/config/app_config.dart';
import 'package:flutter_quill/flutter_quill.dart';

class DocumentPersistence {
  String projectId;
  AppStorage appStorage;

  DocumentPersistence(this.appStorage, this.projectId);

  Future<Document> getProjectDocument() async {
    dynamic result =
        await appStorage.getFromProjectRoot(projectId, 'document.json');
    if (result == null) {
      await appStorage.writeToProjectRoot(
          projectId, 'document.json', r'[{"insert":"hello\n"}]');
    }

    return Document.fromJson(
        await appStorage.getFromProjectRoot(projectId, 'document.json'));
  }

  Future<File> saveDocument(Document document) async {
    return appStorage.writeToProjectRoot(
        projectId, 'document.json', document.toDelta().toJson());
  }
}
