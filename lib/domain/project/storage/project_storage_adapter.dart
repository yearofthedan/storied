import 'package:storied/domain/document/document.dart';
import 'package:storied/domain/project/project.dart';
import 'package:storied/features/add_project/new_project.dart';

abstract class ProjectStorageAdapter {
  Future<Project> add(NewProject newProject);
  Future<bool> delete(Project project);
  Future<Document> getDocument(String pathId);
  Future<Document> saveDocument(String pathId, List<dynamic> updatedContent);
}
