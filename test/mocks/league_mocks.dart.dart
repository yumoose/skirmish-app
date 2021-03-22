import 'package:mocktail/mocktail.dart';
import 'package:skirmish/models/league.dart';

class MockLeague extends Mock implements League {}

abstract class LeagueMocks {
  static Map<String, dynamic> get basicDocument => {
        'name': 'league_name',
      };
}
