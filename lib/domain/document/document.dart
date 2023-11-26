import 'package:storied/domain/project/storage/storage_ref.dart';

class Document {
  final StorageReference _storage;
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

  Document(this._storage, this._data) : dirty = true;

  Future<Document> save() {
    return _storage
        .getClient()
        .saveDocument(_storage.path, data!)
        .then((value) {
      dirty = false;
      return value;
    });
  }
}
