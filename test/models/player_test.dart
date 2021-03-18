import 'package:flutter_test/flutter_test.dart';
import 'package:skirmish/models/player.dart';

void main() {
  final player = Player.fromSnapshot(
    id: 'player-id',
    snapshot: {
      'name': 'player-name',
      'tag': 'player-tag',
    },
  );

  group('fromSnapshot', () {
    test('maps fields correctly', () async {
      expect(player.id, equals('player-id'));
      expect(player.name, equals('player-name'));
      expect(player.tag, equals('player-tag'));
    });
  });
}
