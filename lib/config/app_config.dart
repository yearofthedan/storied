import 'package:storied/config/app_config_storage.dart';
import 'package:storied/config/get_it.dart';

class AppConfig {
  List<dynamic> getProjectList() {
    return List<dynamic>.from(getIt.get<AppConfigStorage>().projectsJson);
  }

  updateProjectList(dynamic projectsList) {
    return getIt
        .get<AppConfigStorage>()
        .setToManifest('projects', projectsList);
  }
}
