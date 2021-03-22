import 'package:equatable/equatable.dart';
import 'package:skirmish/models/player.dart';
import 'package:skirmish/models/league.dart';

class Membership extends Equatable {
  final String id;
  final League league;
  final Player player;

  @override
  List<Object> get props => [id, league, player];

  Membership.fromSnapshot({
    required String id,
    required Map<String, dynamic> snapshot,
  })   : id = id,
        player = Player.fromSnapshot(
          id: snapshot['player_id'] as String,
          snapshot: snapshot['player_snapshot'] as Map<String, dynamic>,
        ),
        league = League.fromSnapshot(
          id: snapshot['league_id'] as String,
          snapshot: snapshot['league_snapshot'] as Map<String, dynamic>,
        );
}
