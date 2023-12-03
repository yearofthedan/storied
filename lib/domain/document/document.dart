import 'package:storied/domain/project/storage/project_storage.dart';

class Document {
  final ProjectStorage storage;
  List<dynamic>? _data;
  get empty {
    return _data == null;
  }

  bool dirty = false;

  set data(List<dynamic>? data) {
    _data = data!;
    dirty = true;
  }

  List<dynamic>? get data {
    return _data;
  }

  Document(this._data, this.storage) : dirty = true;

  Future<Document> save() {
    return storage.saveDocument(_data).then((value) {
      dirty = false;
      return value;
    });
  }
}
