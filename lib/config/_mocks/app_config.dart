import 'package:mocktail/mocktail.dart';
import 'package:storied/config/app_config.dart';
import 'package:storied/config/app_config_storage.dart';

class MockAppConfigStorage extends Mock implements AppConfigStorage {}

class MockAppConfig extends Mock implements AppConfig {
  @override
  updateProjectList(projectsList) {
    return Future.value();
  }
}
