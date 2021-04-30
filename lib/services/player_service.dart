import 'package:skirmish/models/player.dart';
import 'package:skirmish/services/auth_service.dart';
import 'package:skirmish/utils/dependency_injection.dart';

class PlayerService {
  final AuthService _authService;

  PlayerService({AuthService? authService})
      : _authService = authService ?? injected<AuthService>();

  Stream<Player?> get playerStream {
    return _authService.userStream.asyncMap((user) {
      if (user == null) return null;

      // TODO
      return Player.fromSupabase({
        'id': '123',
        'name': 'bob',
        'tag': 'bobB',
      });
    });
  }
}
