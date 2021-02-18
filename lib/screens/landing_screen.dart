import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:skirmish/models/league.dart';

import '../services/league_service.dart';

class LandingScreen extends StatelessWidget {
  final leagueService = GetIt.instance<LeagueService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skirmish'),
      ),
      body: Center(
        child: leagueList(context),
      ),
    );
  }

  Widget leagueList(BuildContext context) {
    return StreamBuilder(
      stream: leagueService.leagues(),
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
}
