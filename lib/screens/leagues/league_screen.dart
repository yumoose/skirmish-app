import 'package:flutter/material.dart';
import 'package:skirmish/exceptions/membership_exception.dart';
import 'package:skirmish/models/league.dart';
import 'package:skirmish/services/league_service.dart';
import 'package:skirmish/services/membership_service.dart';
import 'package:skirmish/utils/dependency_injection.dart';
import 'package:skirmish/widgets/memberships/league_membership_list_view.dart';

final LeagueService _leagueService = injected<LeagueService>();
final MembershipService _membershipService = injected<MembershipService>();

class LeagueScreen extends StatefulWidget {
  final String leagueId;

  LeagueScreen({required this.leagueId});

  @override
  _LeagueScreenState createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen> {
  late League _league;
  bool _isLeagueLoading = true;

  @override
  void initState() {
    _leagueService.league(leagueId: widget.leagueId).listen((league) {
      setState(() {
        _league = league;
        _isLeagueLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLeagueLoading ? 'League Details' : _league.name),
        actions: [
          LeagueMembershipAction(leagueId: widget.leagueId),
        ],
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
                Expanded(child: LeagueMembershipListView(leagueId: league.id)),
                SizedBox(height: 48),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LeagueMembershipAction extends StatelessWidget {
  final String leagueId;

  const LeagueMembershipAction({
    Key? key,
    required this.leagueId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _membershipService.isMemberOfLeague(
        leagueId: leagueId,
      ),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator.adaptive();
        }

        return asyncSnapshot.data == true
            ? TextButton(
                onPressed: () => _updateLeagueMembership(
                  context,
                  action: MembershipAction.leave,
                ),
                style: TextButton.styleFrom(primary: Colors.white),
                child: Text('Leave'),
              )
            : TextButton(
                onPressed: () => _updateLeagueMembership(
                  context,
                  action: MembershipAction.join,
                ),
                style: TextButton.styleFrom(primary: Colors.white),
                child: Text('Join'),
              );
      },
    );
  }

  Future _updateLeagueMembership(
    BuildContext context, {
    required MembershipAction action,
  }) async {
    try {
      await _membershipService.updateMembership(
        leagueId: leagueId,
        action: action,
      );

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Successfully updated membership'),
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
          title: Text("Couldn't update membership"),
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
