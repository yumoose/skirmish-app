import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String id;
  final String name;
  final String tag;

  @override
  List<Object> get props => [id, name, tag];

  Player.fromSnapshot({
    required String id,
    required Map<String, dynamic> snapshot,
  })   : id = id,
        name = snapshot['name'] as String,
        tag = snapshot['tag'] as String;
}
