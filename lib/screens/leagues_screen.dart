import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:skirmish/models/league.dart';
import 'package:skirmish/services/league_service.dart';

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
  final _leagueService = GetIt.instance<LeagueService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<League>>(
      stream: _leagueService.leagues(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error loading leagues');
        }

        final leagues = snapshot.data;
        return ListView(
          children: leagues
              .map(
                (league) => Card(
                  child: ListTile(
                    leading: FlutterLogo(),
                    title: Text(league.name),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
