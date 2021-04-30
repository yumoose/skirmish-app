import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:skirmish/config/locations.dart';
import 'package:skirmish/models/league.dart';
import 'package:skirmish/models/player.dart';
import 'package:skirmish/services/league_service.dart';
import 'package:skirmish/services/player_service.dart';
import 'package:skirmish/utils/dependency_injection.dart';

class LandingScreen extends StatelessWidget {
  final _playerService = injected<PlayerService>();
  final _leagueService = injected<LeagueService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skirmish'),
        actions: [
          _accountAction(),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Beamer.of(context).beamTo(
            LeaguesLocation.leagues(),
          ),
          child: Text('View Leagues'),
        ),
      ),
    );
  }

  Widget leagueList(BuildContext context) {
    return FutureBuilder(
      future: _leagueService.leagues(),
      builder: (
        BuildContext context,
        AsyncSnapshot<Iterable<League>> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        final leagues = snapshot.data!;

        return Column(
          children: leagues.map((league) => Text(league.name)).toList(),
        );
      },
    );
  }

  Widget _accountAction() {
    return StreamBuilder<Player?>(
      stream: _playerService.playerStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Sign in',
            onPressed: () => Beamer.of(context).beamTo(AuthLocation()),
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Account',
            onPressed: () => Beamer.of(context).beamTo(AccountLocation()),
          );
        }
      },
    );
  }
}
