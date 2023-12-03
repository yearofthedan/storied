import 'package:flutter/material.dart';
import 'package:storied/clients/google_apis_provider.dart';
import 'package:storied/config/get_it.dart';
import 'package:storied/domain/project/storage/project_storage_adapter_config.dart';
import 'package:storied/features/home/terms.dart';
import 'package:watch_it/watch_it.dart';

const desktopPlatforms = [
  TargetPlatform.macOS,
  TargetPlatform.linux,
  TargetPlatform.windows
];

class GoogleAccountLink extends WatchingWidget {
  const GoogleAccountLink({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSignedIn =
        watchPropertyValue<GoogleApisProvider, bool>((g) => g.isSignedIn);

    if (desktopPlatforms.contains(Theme.of(context).platform)) {
      return Container();
    }

    if (isSignedIn) {
      return FilledButton.icon(
          icon: const Icon(Icons.link_off),
          onPressed: _handleSignOut,
          label: const Text(appIntegration_UnlinkGoogle_Label));
    }
    return ElevatedButton(
        onPressed: _handleSignIn,
        child: const Text(appIntegration_LinkGoogle_Label));
  }

  Future<void> _handleSignIn() async {
    getIt<GoogleApisProvider>().signIn();
    getIt<ProjectStorageAdapterConfig>()
        .enabledStorage
        .add(StorageAdapterType.gdrive);
  }

  Future<void> _handleSignOut() async {
    getIt<GoogleApisProvider>().signOut();
    getIt<ProjectStorageAdapterConfig>()
        .enabledStorage
        .remove(StorageAdapterType.gdrive);
  }
}
