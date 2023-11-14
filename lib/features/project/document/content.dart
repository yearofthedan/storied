import 'package:storied/common/storage/clients/abstract_storage_client.dart';

class Content<T> {
  final AbstractStorageClient storageClient;
  final String path;
  final T Function(String) decoder;
  final String Function(T) encoder;

  T? _data;

  get data {
    return _data;
  }

  Content(this.storageClient, this.path,
      {required this.decoder, required this.encoder});

  save(T content) async {
    await storageClient.writeFile(path, encoder(content));
    _data = content;
    return true;
  }

  Future<T?> load() async {
    var rawData = await storageClient.getFileData(path);

    if (rawData == null) {
      return null;
    }

    _data = decoder(rawData);
    return _data;
  }
}
