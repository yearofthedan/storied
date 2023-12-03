import 'package:storied/domain/document/document.dart';
import 'package:storied/domain/project/_mocks/project_storage.dart';

const someData = [
  {'insert': 'words  \n'}
];

buildDocument({data = someData, projectStorage}) {
  return Document(data, projectStorage ?? MockProjectStorage());
}
