import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _firebaseAuth;
  AuthService({FirebaseAuth firebaseAuth}) {
    _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.userChanges();
  }

  User get currentUser => _firebaseAuth.currentUser;
  bool get isLoggedIn => currentUser != null;

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user;
  }

  Future<User> createUserWithEmailAndPassword({
    String email,
    String password,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user;
  }

  Future resetPassword({User user}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: user.email);
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
  }
}
