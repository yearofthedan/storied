import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class Project {
  final String name;
  final String id;

  Project(this.id, this.name);

  Project.newWithName(this.name) : id = uuid.v4();

  Map<String, dynamic> toJson() => {'name': name, 'id': id};
}
