import 'package:storied/domain/project/project.dart';
import 'package:storied/domain/project/storage/_mocks/project_storage.dart';
import 'package:storied/domain/project/storage/storage_ref.dart';

Project buildProject(
    {name = 'Some name', id = 'some-id', StorageReference? storage}) {
  var json = {
    'id': id,
    'name': name,
    'storage': (storage ?? buildStorageRef()).toJson(),
  };

  return Project.fromJson(json);
}
