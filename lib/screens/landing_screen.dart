import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:skirmish/config/locations.dart';
import 'package:skirmish/models/league.dart';
import 'package:skirmish/models/player.dart';
import 'package:skirmish/services/auth_service.dart';
import 'package:skirmish/services/league_service.dart';

class LandingScreen extends StatelessWidget {
  final _authService = GetIt.instance<AuthService>();
  final _leagueService = GetIt.instance<LeagueService>();

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
        child: leagueList(context),
      ),
    );
  }

  Widget leagueList(BuildContext context) {
    return StreamBuilder(
      stream: _leagueService.leagues(),
      builder: (BuildContext context, AsyncSnapshot<List<League>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        final leagues = snapshot.data;

        return Column(
          children: leagues.map((league) => Text(league.name)).toList(),
        );
      },
    );
  }

  Widget _accountAction() {
    return StreamBuilder<Player>(
      stream: _authService.currentPlayer,
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
