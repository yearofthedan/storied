import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storied/clients/_mocks/google_apis_mocks.dart';
import 'package:storied/clients/google_apis_provider.dart';
import 'package:storied/common/exceptions.dart';
import 'package:storied/config/get_it.dart';

class MockObservability extends Mock implements Observability {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(GoogleApisProvider, () {
    late MockGoogleSignIn mockGoogleSignIn;
    late MockObservability mockObservability;

    setUp(() {
      mockGoogleSignIn = MockGoogleSignIn();
      mockObservability = MockObservability();
      getIt.registerSingleton<Observability>(mockObservability);
    });

    tearDown(() {
      getIt.reset();
    });

    group('signIn', () {
      test('should capture exception with appropriate message on error',
          () async {
        const error = 'Error signing in';
        final stackTrace = StackTrace.current;

        when(() => mockGoogleSignIn.signIn()).thenAnswer(
          (_) => Future<GoogleSignInAccount?>.error(error, stackTrace),
        );

        await GoogleApisProvider(mockGoogleSignIn).signIn();

        verify(() => mockObservability.captureException(
              exception: error,
              stack: stackTrace,
              message: 'Failed to sign in with Google',
            )).called(1);
      });
    });

    group('signOut', () {
      test('should capture exception with appropriate message on error',
          () async {
        const error = 'Error signing out';
        final stackTrace = StackTrace.current;

        when(() => mockGoogleSignIn.signOut()).thenAnswer(
          (_) => Future<GoogleSignInAccount?>.error(error, stackTrace),
        );

        await GoogleApisProvider(mockGoogleSignIn).signOut();

        verify(() => mockObservability.captureException(
              exception: error,
              stack: stackTrace,
              message: 'Failed to sign out',
            )).called(1);
      });
    });

    group('isSignedIn', () {
      test('should return true once user is signed in', () async {
        final mockAccount = MockGoogleSignInAccount();
        final provider = GoogleApisProvider(mockGoogleSignIn);
        mockGoogleSignIn.authStream.add(mockAccount);
        await Future.delayed(Duration.zero); // respond to the stream update

        expect(provider.isSignedIn, true);
      });

      test('should return false until user is not signed in', () {
        final result = GoogleApisProvider(mockGoogleSignIn).isSignedIn;

        expect(result, false);
      });
    });
  });
}
