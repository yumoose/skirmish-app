import 'package:flutter_test/flutter_test.dart';
import 'package:skirmish/models/league.dart';
import 'package:skirmish/models/membership.dart';
import 'package:skirmish/models/player.dart';

import '../mocks/league_mocks.dart.dart';
import '../mocks/player_mocks.dart';

void main() {
  final membership = Membership.fromSnapshot(
    id: 'membership-id',
    snapshot: {
      'name': 'membership-name',
      'player_id': 'player_id',
      'player_snapshot': PlayerMocks.basicDocument,
      'league_id': 'league_id',
      'league_snapshot': LeagueMocks.basicDocument,
    },
  );

  group('fromSnapshot', () {
    test('maps fields correctly', () async {
      expect(membership.id, equals('membership-id'));

      expect(
        membership.player,
        equals(Player.fromSnapshot(
          id: 'player_id',
          snapshot: PlayerMocks.basicDocument,
        )),
      );
      expect(
        membership.league,
        equals(League.fromSnapshot(
          id: 'league_id',
          snapshot: LeagueMocks.basicDocument,
        )),
      );
    });
  });
}
