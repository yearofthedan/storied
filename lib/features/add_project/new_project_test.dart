import 'package:storied/config/get_it.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:storied/features/add_project/new_project.dart';
import 'package:uuid/uuid.dart';

void main() {
  setUp(() {
    getIt.reset();
  });
  group(NewProject, () {
    group('newWithName', () {
      test('creates from a name and generates an id', () async {
        var project = NewProject('some name', StorageAdapterType.local);

        expect(project.name, 'some name');
        expect(Uuid.isValidUUID(fromString: project.id), true);
      });
    });
  });
}
