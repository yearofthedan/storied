import 'package:storied/domain/document/document.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:storied/domain/project/storage/storage_ref.dart';

const someStorage =
    StorageReference(path: 'path/to/file', type: StorageAdapterType.local);
const someData = [
  {'insert': 'words  \n'}
];

buildDocument({storage = someStorage, data = someData}) {
  return Document(storage, data);
}
