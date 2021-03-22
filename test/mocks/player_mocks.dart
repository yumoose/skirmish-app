import 'package:mocktail/mocktail.dart';
import 'package:skirmish/models/player.dart';

class MockPlayer extends Mock implements Player {}

abstract class PlayerMocks {
  static Map<String, dynamic> get basicDocument => {
        'name': 'player_name',
        'tag': 'player_tag',
      };
}
