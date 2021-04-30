import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String id;
  final String name;
  final String tag;

  @override
  List<Object> get props => [id, name, tag];

  Player.fromSupabase(playerData)
      : id = playerData['id'] as String,
        name = playerData['name'] as String,
        tag = playerData['tag'] as String;
}
