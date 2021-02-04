// ignore: import_of_legacy_library_into_null_safe
import 'package:get_it/get_it.dart';
import 'package:skirmish/services/auth_service.dart';

abstract class ServiceConfiguration {
  static void registerServices() {
    final getIt = GetIt.instance;
    getIt.allowReassignment = true;

    getIt.registerLazySingleton<AuthService>(() => AuthService());
  }
}
