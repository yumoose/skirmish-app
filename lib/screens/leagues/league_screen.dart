import 'package:flutter/material.dart';
import 'package:skirmish/exceptions/membership_exception.dart';
import 'package:skirmish/models/league.dart';
import 'package:skirmish/services/league_service.dart';
import 'package:skirmish/services/membership_service.dart';
import 'package:skirmish/utils/dependency_injection.dart';

class LeagueScreen extends StatefulWidget {
  final String leagueId;

  LeagueScreen({required this.leagueId});

  @override
  _LeagueScreenState createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen> {
  final LeagueService _leagueService = injected<LeagueService>();
  final MembershipService _membershipService = injected<MembershipService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('League Details'),
      ),
      body: Center(
        child: StreamBuilder<League>(
          stream: _leagueService.league(leagueId: widget.leagueId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error loading league details');
            }

            final league = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(league.name),
                SizedBox(height: 48),
                ElevatedButton(
                  onPressed: _joinLeague,
                  child: Text('Join league'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future _joinLeague() async {
    try {
      await _membershipService.joinLeague(
        leagueId: widget.leagueId,
      );

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Successfully joined league'),
          content: Text('Time to jump in and start logging your victories!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ok'),
            )
          ],
        ),
      );
    } on MembershipException catch (ex) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Couldn't join league"),
          content: Text(ex.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ok'),
            )
          ],
        ),
      );
    }
  }
}
