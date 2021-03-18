import 'package:equatable/equatable.dart';

class League extends Equatable {
  final String id;
  final String name;

  @override
  List<Object> get props => [id, name];

  League.fromSnapshot({
    required String id,
    required Map<String, dynamic> snapshot,
  })   : id = id,
        name = snapshot['name'] as String;
}
