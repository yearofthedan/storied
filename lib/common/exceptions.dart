import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

captureException(
    {dynamic exception, dynamic stack, message = 'Unexpected exception'}) {
  if (kReleaseMode) {
    Sentry.captureException(
      exception,
      stackTrace: stack,
    );
  } else {
    Logger().e(message, error: exception, stackTrace: stack);
  }
}

class Observability {
  captureException(
      {dynamic exception, dynamic stack, message = 'Unexpected exception'}) {
    if (kReleaseMode) {
      Sentry.captureException(
        exception,
        stackTrace: stack,
      );
    } else {
      Logger().e(message, error: exception, stackTrace: stack);
    }
  }
}
