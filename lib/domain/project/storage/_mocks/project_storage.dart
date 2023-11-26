import 'package:mocktail/mocktail.dart';
import 'package:storied/domain/project/storage/local_project_storage_adapter.dart';
import 'package:storied/domain/project/storage/project_storage_adapter.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:storied/domain/project/storage/storage_ref.dart';

StorageReference buildStorageRef(
    {path = '/path', type = StorageAdapterType.local}) {
  return StorageReference(path: path, type: type);
}

class MockLocalProjectStorageAdapter extends Mock
    implements LocalProjectStorageAdapter {}

class MockProjectStorageAdapter extends Mock implements ProjectStorageAdapter {}

class MockProjectStorageAdapterConfig extends Mock
    implements ProjectStorageAdapterConfig {
  final adapter = MockProjectStorageAdapter();

  @override
  MockProjectStorageAdapter getClient(_) {
    return adapter;
  }
}
