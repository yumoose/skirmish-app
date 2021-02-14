import 'package:flutter_test/flutter_test.dart';
import 'package:skirmish/models/player.dart';

void main() {
  final player = Player(
    id: 'player-id',
    tag: 'playa',
    name: 'Player One',
  );

  group('userId', () {
    test('is the same as the player\'s ID', () async {
      expect(player.userId, equals(player.id));
    });
  });
}
