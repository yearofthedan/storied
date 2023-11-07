import 'package:mocktail/mocktail.dart';
import 'package:storied/common/storage/app_storage.dart';

class MockAppConfig extends Mock implements AppConfig {
  @override
  List<dynamic> projects = List.of([]);
}
