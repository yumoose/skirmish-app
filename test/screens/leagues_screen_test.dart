import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skirmish/models/league.dart';
import 'package:skirmish/screens/leagues_screen.dart';
import 'package:skirmish/services/league_service.dart';

import '../helpers/app_under_test_helper.dart';
import '../helpers/goldens_helper.dart';
import '../mocks/league_mocks.dart.dart';
import '../mocks/services/mock_league_service.dart';

void main() {
  final _getIt = GetIt.instance;
  _getIt.allowReassignment = true;

  void _setupServices({required Stream<Iterable<League>> leaguesStream}) {
    final mockLeagueService = MockLeagueService();
    when(() => mockLeagueService.leagues()).thenAnswer((_) => leaguesStream);

    _getIt.registerLazySingleton<LeagueService>(() => mockLeagueService);
  }

  testGoldens('matches goldens', (tester) async {
    await AppUnderTestHelper.prepare();

    final leaguesStreamController =
        StreamController<Iterable<League>>.broadcast();
    _setupServices(leaguesStream: leaguesStreamController.stream);

    final noLeagues = Scenario(
      widget: LeaguesScreen(),
      name: 'with no leagues',
      onCreate: (Key key) async {
        leaguesStreamController.add([]);
      },
    );

    final singleLeague = Scenario(
      widget: LeaguesScreen(),
      name: 'with a single league',
      onCreate: (Key key) async {
        final league = League.fromSnapshot(
          id: 'league-1',
          snapshot: LeagueMocks.basicDocument,
        );

        leaguesStreamController.add([
          league,
        ]);
      },
    );

    final multipleLeagues = Scenario(
      widget: LeaguesScreen(),
      name: 'with multiple leagues',
      onCreate: (Key key) async {
        final league = League.fromSnapshot(
          id: 'league-1',
          snapshot: LeagueMocks.basicDocument,
        );

        leaguesStreamController.add([
          league,
          league,
          league,
          league,
        ]);
      },
    );

    await GoldensHelper.matchesScreen(
      tester,
      'Account screen',
      [
        noLeagues,
        singleLeague,
        multipleLeagues,
      ],
    );
  });
}
