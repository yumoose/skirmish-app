import 'package:get_it/get_it.dart';
import 'package:skirmish/services/membership_service.dart';
import 'package:skirmish/services/player_service.dart';

import '../services/auth_service.dart';
import '../services/league_service.dart';

abstract class ServiceConfiguration {
  static void registerServices() {
    final getIt = GetIt.instance;

    getIt.registerLazySingleton<AuthService>(() => AuthService());
    getIt.registerLazySingleton<PlayerService>(() => PlayerService());
    getIt.registerLazySingleton<LeagueService>(() => LeagueService());
    getIt.registerLazySingleton<MembershipService>(() => MembershipService());
  }
}
