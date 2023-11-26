import 'package:flutter/material.dart';
import 'package:storied/common/exceptions.dart';
import 'package:storied/domain/document/document.dart';
import 'package:storied/domain/project/storage/storage_ref.dart';
import 'package:storied/features/add_project/new_project.dart';

class Project extends ChangeNotifier {
  final String name;
  final String id;
  StorageReference storage;
  bool _deleted = false;

  set deleted(value) {
    _deleted = value;
    notifyListeners();
  }

  get deleted {
    return _deleted;
  }

  Project(NewProject project, this.storage)
      : id = project.id,
        name = project.name;

  Project.fromJson(json)
      : id = json['id'],
        name = json['name'],
        storage = StorageReference.fromJson(json['storage']);

  Future<Document> get storedDocument {
    return storage.getClient().getDocument(storage.path);
  }

  Future<Project> delete() async {
    try {
      deleted = await storage.getClient().delete(this);
      return this;
    } catch (e, s) {
      captureException(
          exception: e, stack: s, message: 'Unable to delete project');
      return this;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'storage': storage.toJson(),
    };
  }
}
