import 'package:flutter/material.dart';
import 'package:skirmish/models/membership.dart';
import 'package:skirmish/services/membership_service.dart';
import 'package:skirmish/utils/dependency_injection.dart';

final _membershipService = injected<MembershipService>();

class LeagueMembershipListView extends StatelessWidget {
  final String leagueId;

  const LeagueMembershipListView({
    Key? key,
    required this.leagueId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<Membership>>(
        stream: _membershipService.leagueMemberships(leagueId: leagueId),
        builder: (context, asyncSnapshot) {
          final listItems = asyncSnapshot.data?.map<ListTile>(
                (membership) => MembershipTile(membership: membership),
              ) ??
              <ListTile>[LoadingTile()];

          return ListView.builder(
            itemCount: listItems.length,
            itemBuilder: (content, index) => listItems.elementAt(index),
          );
        });
  }
}

class MembershipTile extends ListTile {
  final Membership membership;

  const MembershipTile({Key? key, required this.membership}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(membership.player.tag),
      subtitle: Text(membership.player.name),
    );
  }
}

class LoadingTile extends ListTile {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Loading players'),
    );
  }
}
