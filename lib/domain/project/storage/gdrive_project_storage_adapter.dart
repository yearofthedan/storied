import 'package:storied/domain/project/project.dart';
import 'package:storied/domain/project/storage/project_storage_adapter.dart';
import 'package:storied/features/add_project/new_project.dart';

class GDriveProjectStorage implements ProjectStorageAdapter {
  @override
  add(NewProject newProject) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  delete(Project project) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  getDocument(String id) {
    // TODO: implement getContent
    throw UnimplementedError();
  }

  @override
  saveDocument(String id, List updatedContent) {
    // TODO: implement saveContent
    throw UnimplementedError();
  }
}
