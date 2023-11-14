import 'package:storied/domain/storage_ref.dart';

abstract class AbstractStorageClient {
  Future<String?> getFileData(String path);
  Future<StorageRef> createDir(String path);
  Future<dynamic> writeFile(String path, dynamic data);
  Future<List<String>> listFiles({String? path});

  Future<bool> deleteDir(String id);
}
