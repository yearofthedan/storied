import 'package:mocktail/mocktail.dart';
import 'package:storied/domain/project/project.dart';
import 'package:storied/domain/project/storage/project_storage.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';

class MockProjectStorage extends Mock implements ProjectStorage {
  @override
  final StorageAdapterType type = StorageAdapterType.local;

  @override
  get pathToProject => 'some-path';
}

Project buildProject({name = 'Some name', id = 'some-id', storage}) {
  return Project(id, name, storage ?? MockProjectStorage());
}
