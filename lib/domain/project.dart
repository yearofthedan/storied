import 'package:flutter/material.dart';
import 'package:storied/common/exceptions.dart';
import 'package:storied/common/get_it.dart';
import 'package:storied/domain/project_storage.dart';
import 'package:storied/domain/storage_ref.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class Project extends ChangeNotifier {
  final String name;
  final String id;
  StorageRef? storage;
  bool _deleted = false;

  Project(this.id, this.name, this.storage);

  Project.newWithName(this.name) : id = uuid.v4();

  Project.fromJson(e)
      : id = e['id'],
        name = e['name'],
        storage = StorageRef.fromJson(e['storage']);

  Map<String, dynamic> toJson() => {'name': name, 'id': id};

  set deleted(value) {
    _deleted = value;
    notifyListeners();
  }

  get deleted {
    return _deleted;
  }

  Future<Project> delete() async {
    try {
      deleted = await getIt.get<ProjectStorage>().delete(this);
      return this;
    } catch (e, s) {
      captureException(
          exception: e, stack: s, message: 'Unable to delete project');
      return this;
    }
  }
}
