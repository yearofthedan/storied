import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:flutter/foundation.dart';
import 'package:googleapis/keep/v1.dart';
import 'package:storied/common/exceptions.dart';
import 'package:storied/config/get_it.dart';

class GoogleApisProvider with ChangeNotifier {
  late GoogleSignIn _googleSignIn;
  bool isSignedIn = false;

  factory GoogleApisProvider.driveScoped() {
    var signIn = GoogleSignIn.standard(
      scopes: [drive.DriveApi.driveScope],
    );
    return GoogleApisProvider(signIn);
  }

  GoogleApisProvider(this._googleSignIn) {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      isSignedIn = account != null;
      notifyListeners();
    });
  }

  Future<drive.DriveApi> _getDriveApi() async {
    var client = await _googleSignIn.authenticatedClient();

    final driveApi = drive.DriveApi(client!);
    return driveApi;
  }

  Future<String> createDir(String name) async {
    drive.File fileMetadata =
        drive.File(name: name, mimeType: 'application/vnd.google-apps.folder');
    drive.File ref = await _getDriveApi().then((client) {
      return client.files.create(fileMetadata);
    });
    return ref.id!;
  }

  Future<String> createFile(
      String title, String parentId, String content) async {
    drive.File fileMetadata = drive.File(
      name: title,
      mimeType: 'application/json',
      parents: [parentId],
    );
    var media = drive.Media(Stream.value(content.codeUnits), null,
        contentType: 'application/json');

    drive.File ref = await _getDriveApi().then((client) {
      return client.files.create(fileMetadata, uploadMedia: media);
    });
    return ref.id!;
  }

  Future<String> writeFile(String id, String content) async {
    drive.File fileMetadata =
        drive.File(name: 'TestFolder', mimeType: 'application/json', id: id);
    var media = drive.Media(Stream.value(content.codeUnits), null,
        contentType: 'application/json');

    drive.File ref = await _getDriveApi().then((client) {
      return client.files.update(fileMetadata, id, uploadMedia: media);
    });
    return ref.id!;
  }

  Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error, stack) {
      getIt<Observability>().captureException(
          exception: error,
          stack: stack,
          message: 'Failed to sign in with Google');
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (error, stack) {
      getIt<Observability>().captureException(
          exception: error, stack: stack, message: 'Failed to sign out');
    }
  }

  Future<bool> deleteFile(String id) async {
    await _getDriveApi().then((client) {
      client.files.delete(id);
    });
    return true;
  }

  getFile(String id) async {
    String data = await _getDriveApi()
        .then((client) =>
            client.files.get(id, downloadOptions: DownloadOptions.fullMedia))
        .then((response) => utf8.decodeStream((response as Media).stream));
    return data;
  }
}
