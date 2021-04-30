import 'package:equatable/equatable.dart';
import 'package:skirmish/models/player.dart';
import 'package:skirmish/models/league.dart';

class Membership extends Equatable {
  final String id;
  final League league;
  final Player player;
  final DateTime? expiredAt;
  final int rating;

  @override
  List<Object> get props => [id, league, player];

  Membership.fromSupabase(membershipData)
      : id = membershipData['id'] as String,
        player = Player.fromSupabase(membershipData['player']),
        league = League.fromSupabase(membershipData['league']),
        expiredAt = membershipData['expired_at'] as DateTime?,
        rating = membershipData['rating'] as int;

  bool get isExpired =>
      expiredAt != null &&
      expiredAt!.isBefore(
        DateTime.now(),
      );

  bool get isActive => !isExpired;
}
