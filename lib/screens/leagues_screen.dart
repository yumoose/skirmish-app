import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:skirmish/config/locations.dart';
import 'package:skirmish/models/league.dart';
import 'package:skirmish/services/league_service.dart';
import 'package:skirmish/utils/dependency_injection.dart';

class LeaguesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leagues'),
      ),
      body: Center(
        child: LeagueList(),
      ),
    );
  }
}

class LeagueList extends StatelessWidget {
  final LeagueService _leagueService = injected<LeagueService>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Iterable<League>>(
      future: _leagueService.leagues(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error loading leagues');
        }

        final leagues = snapshot.data!;
        return ListView(
          children: leagues
              .map(
                (league) => Card(
                  child: ListTile(
                    leading: FlutterLogo(),
                    title: Text('${league.name}'),
                    onTap: () => Beamer.of(context).beamTo(
                      LeaguesLocation.league(leagueId: league.id),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
