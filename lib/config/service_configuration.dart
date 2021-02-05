import 'package:get_it/get_it.dart';

import '../services/auth_service.dart';
import '../services/league_service.dart';

abstract class ServiceConfiguration {
  static void registerServices() {
    final getIt = GetIt.instance;
    getIt.allowReassignment = true;

    getIt.registerLazySingleton<AuthService>(() => AuthService());
    getIt.registerLazySingleton<LeagueService>(() => LeagueService());
  }
}
