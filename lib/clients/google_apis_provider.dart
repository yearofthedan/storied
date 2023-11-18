import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:flutter/foundation.dart';
import 'package:storied/common/exceptions.dart';
import 'package:storied/common/get_it.dart';

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
}
