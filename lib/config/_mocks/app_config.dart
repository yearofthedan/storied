import 'package:mocktail/mocktail.dart';
import 'package:storied/config/app_config.dart';
import 'package:storied/config/app_config_storage.dart';

class MockAppConfigStorage extends Mock implements AppConfigStorage {
  @override
  List<dynamic> projectsJson = List.of([]);
}

class MockAppConfig extends Mock implements AppConfig {
  @override
  getProjectList() {
    return [];
  }

  @override
  updateProjectList(projectsList) {
    return projectsList;
  }
}
