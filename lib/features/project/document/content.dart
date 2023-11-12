import 'package:storied/common/storage/clients/abstract_storage_client.dart';

class Content<T> {
  final AbstractStorageClient storageClient;
  final String path;
  final Function(dynamic) decoder;
  final Function(dynamic) encoder;

  T? _data;

  get data {
    return _data;
  }

  Content(this.storageClient, this.path, this.decoder, this.encoder);

  save(dynamic content) async {
    await storageClient.writeFile(path, encoder(content));
    _data = content;
    return true;
  }

  Future<T> load() {
    return storageClient
        .getFileData(path)
        .then((saved) => decoder(saved))
        .then((decoded) {
      _data = decoded;
      return data!;
    });
  }
}
