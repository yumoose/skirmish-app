import 'package:flutter_test/flutter_test.dart';
import 'package:skirmish/models/league.dart';

void main() {
  final league = League.fromSnapshot(
    id: 'league-id',
    snapshot: {
      'name': 'league-name',
    },
  );

  group('fromSnapshot', () {
    test('maps fields correctly', () async {
      expect(league.id, equals('league-id'));
      expect(league.name, equals('league-name'));
    });
  });
}
