import 'package:storied/domain/project.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

const root = 'root/com.app';

void main() {
  group('project', () {
    test('creates from a name and generates an id', () async {
      var project = Project.newWithName('some name');

      expect(project.name, 'some name');
      expect(Uuid.isValidUUID(fromString: project.id), true);
    });
  });
}
