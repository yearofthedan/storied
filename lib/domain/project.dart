import 'package:storied/common/get_it.dart';
import 'package:storied/domain/project_storage.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class Project {
  final String name;
  final String id;

  Project(this.id, this.name);

  Project.newWithName(this.name) : id = uuid.v4();

  Project.fromJson(e)
      : id = e['id'],
        name = e['name'];

  Map<String, dynamic> toJson() => {'name': name, 'id': id};

  delete() {
    return getIt.get<ProjectStorage>().delete(this);
  }
}
