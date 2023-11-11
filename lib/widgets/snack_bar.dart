import 'package:flutter/material.dart';

class SnackBarBuilder {
  static error(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      showCloseIcon: true,
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  }

  static success(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      showCloseIcon: true,
      backgroundColor: Theme.of(context).colorScheme.secondary,
    ));
  }
}
