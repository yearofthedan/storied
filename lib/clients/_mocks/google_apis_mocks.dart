import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/clients/google_apis_provider.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {
  final authStream = StreamController<GoogleSignInAccount?>();

  @override
  Stream<GoogleSignInAccount?> get onCurrentUserChanged => authStream.stream;
}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleApisProvider extends Mock implements GoogleApisProvider {}
