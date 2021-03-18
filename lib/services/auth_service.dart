import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skirmish/models/player.dart';

class AuthService {
  late FirebaseAuth _firebaseAuth;
  late FirebaseFirestore _firestore;

  AuthService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) {
    _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
    _firestore = firestore ?? FirebaseFirestore.instance;
  }

  Stream<Player?> get currentPlayer {
    return _firebaseAuth.userChanges().asyncMap(
          (user) async => user != null
              ? await _fetchPlayer(
                  id: user.uid,
                )
              : null,
        );
  }

  User? get currentUser => _firebaseAuth.currentUser;
  bool get isLoggedIn => currentUser != null;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user;
  }

  Future<Player> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
    String? tag,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final player = await _createSkirmishUserProfile(
      user: userCredential.user!,
      name: name,
      tag: tag,
    );

    return player;
  }

  Future resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<Player> _fetchPlayer({String? id}) async {
    final playerRef = _firestore.collection('players').doc(id);
    final updatedPlayerDoc = await playerRef.get();

    return Player.fromDocumentSnapshot(updatedPlayerDoc);
  }

  Future<Player> _createSkirmishUserProfile({
    required User user,
    required String? name,
    required String? tag,
  }) async {
    final playerRef = _firestore.collection('players').doc(user.uid);

    await playerRef.set({
      'name': name,
      'tag': tag,
    }, SetOptions(merge: true));

    return _fetchPlayer(id: user.uid);
  }
}
