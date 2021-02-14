/// The [Match] information for a [Game] played as part of a [Tournament]
class Match {
  Match({
    this.id,
    this.tournamentId,
    this.playerAId,
    this.playerBId,
    this.winerId,
    this.nextMatchId,
  });

  final String id;
  String tournamentId;
  String playerAId;
  String playerBId;
  String winerId;
  String nextMatchId;
}
