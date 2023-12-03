import 'package:flutter/material.dart';
import 'package:storied/common/exceptions.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/domain/document/document.dart';
import 'package:storied/domain/project/storage/project_storage.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';

class Project extends ChangeNotifier {
  late String name;
  late String id;
  late ProjectStorage storage;
  bool _deleted = false;

  set deleted(value) {
    _deleted = value;
  }

  get deleted {
    return _deleted;
  }

  Project(this.id, this.name, this.storage);

  Project.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    storage = getIt<ProjectStorageAdapterConfig>()
        .projectStorageClientFromJson(json['storage']);
  }

  Future<Document> get storedDocument {
    return storage.getDocument();
  }

  Future<Project> delete() async {
    try {
      deleted = await storage.delete();
      notifyListeners();
      return this;
    } catch (e, s) {
      captureException(
          exception: e, stack: s, message: 'Unable to delete project');
      return this;
    }
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'id': id, 'storage': storage.toJson()};
  }
}
