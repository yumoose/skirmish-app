import 'package:flutter_test/flutter_test.dart';
import 'package:skirmish/models/league.dart';
import 'package:skirmish/models/membership.dart';
import 'package:skirmish/models/player.dart';

import '../mocks/league_mocks.dart.dart';
import '../mocks/player_mocks.dart';

void main() {
  final membershipId = 'membership-id';
  final rating = 1000;

  final playerId = 'player-id';
  final leagueId = 'league-id';

  final membership = Membership.fromSnapshot(
    id: 'membership-id',
    snapshot: {
      'player_id': playerId,
      'player_snapshot': PlayerMocks.basicDocument,
      'league_id': leagueId,
      'league_snapshot': LeagueMocks.basicDocument,
      'rating': rating,
    },
  );

  group('fromSnapshot', () {
    test('maps fields correctly', () async {
      expect(membership.id, equals(membershipId));
      expect(membership.rating, equals(rating));

      expect(
        membership.player,
        equals(Player.fromSnapshot(
          id: playerId,
          snapshot: PlayerMocks.basicDocument,
        )),
      );
      expect(
        membership.league,
        equals(League.fromSnapshot(
          id: leagueId,
          snapshot: LeagueMocks.basicDocument,
        )),
      );
    });
  });
}
