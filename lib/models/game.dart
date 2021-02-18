// import 'package:skirmish/models/player.dart';

class Game {
  final String leagueId;
  final String playerAId;
  final String playerBId;
  final String loggedByUserId;
  final String confirmedByUserId;
  final DateTime confirmedAt;
  final int ratingDelta;

  Game({
    this.leagueId,
    this.playerAId,
    this.playerBId,
    this.loggedByUserId,
    this.confirmedByUserId,
    this.confirmedAt,
    this.ratingDelta,
  });
}
