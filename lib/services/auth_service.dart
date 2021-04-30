import 'dart:async';

import 'package:skirmish/exceptions/auth_exception.dart';
import 'package:skirmish/utils/supabase.dart';
import 'package:supabase/supabase.dart';

class AuthService {
  final SupabaseClient _supabase;

  AuthService() : _supabase = Supabase.client;

  User? get currentUser => _supabase.auth.user();
  bool get isLoggedIn => currentUser != null;

  Stream<User?> get userStream {
    late StreamController<User?> controller;
    var active = true;

    void update(User? user) {
      controller.add(user);
      if (!active) {
        controller.close();
      }
    }

    void start() {
      _supabase.auth.onAuthStateChange((event, session) {
        if (active) {
          update(session?.user);
        }
      });
    }

    void stop() {
      active = false;
    }

    controller = StreamController<User>(
        onListen: start, onPause: stop, onResume: start, onCancel: stop);

    return controller.stream;
  }

  Future<User> signIn(
    String email,
    String password,
  ) async {
    final sessionResponse = await _supabase.auth.signIn(
      email: email,
      password: password,
    );

    if (sessionResponse.error != null) {
      throw AuthException(sessionResponse.error!.message);
    }

    return sessionResponse.user!;
  }

  Future<User> register({
    required String email,
    required String password,
    String? name,
    String? tag,
  }) async {
    final sessionResponse = await _supabase.auth.signUp(email, password);

    if (sessionResponse.error != null) {
      throw AuthException(sessionResponse.error!.message);
    }

    // TODO: Create user/player in the database - split out profile service?

    return sessionResponse.user!;
  }

  Future resetPassword({required String email}) async {
    // TODO: Configure password reset in the app itself
    await _supabase.auth.api.resetPasswordForEmail(email);
  }

  Future signOut() async {
    await _supabase.auth.signOut();
  }

  Future assertLoggedIn() async {
    if (!isLoggedIn) throw MustBeLoggedInException();
  }
}
