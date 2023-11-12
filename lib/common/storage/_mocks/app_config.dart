import 'package:mocktail/mocktail.dart';
import 'package:storied/common/storage/app_config_storage.dart';

class MockAppConfig extends Mock implements AppConfigStorage {
  @override
  List<dynamic> projectsJson = List.of([]);
}
