import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final String _root;

  FakePathProviderPlatform(this._root);
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return _root;
  }
}
