import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get_it/get_it.dart';
import 'package:skirmish/exceptions/auth_exception.dart';
import 'package:skirmish/exceptions/membership_exception.dart';
import 'package:skirmish/models/membership.dart';
import 'package:skirmish/services/auth_service.dart';
import 'package:skirmish/utils/cloud_functions.dart';

class MembershipService {
  final _injected = GetIt.instance;

  late FirebaseFirestore _firestore;
  late AuthService _authService;

  MembershipService({
    FirebaseFirestore? firestore,
    AuthService? authService,
  }) {
    _firestore = firestore ?? FirebaseFirestore.instance;
    _authService = authService ?? _injected<AuthService>();
  }

  CollectionReference get _membershipsCollection =>
      _firestore.collection('memberships');

  Stream<Iterable<Membership>> memberships() {
    return _membershipsCollection.snapshots().map((membershipsQuery) {
      return membershipsQuery.docs.map(
        (membershipDocument) => Membership.fromSnapshot(
          id: membershipDocument.id,
          snapshot: membershipDocument.data()!,
        ),
      );
    });
  }

  static final _joinLeagueFunction =
      cloudFunctions.httpsCallable('memberships-joinLeague');

  Future<void> joinLeague({required String leagueId}) async {
    try {
      await _authService.assertLoggedIn();
      await _assertNotAlreadyInLeague(leagueId: leagueId);

      await _joinLeagueFunction.call({
        'playerId': _authService.currentUser?.uid,
        'leagueId': leagueId,
      });
    } on MustBeLoggedInException catch (_) {
      throw MembershipException('You must be logged in to join leagues.');
    } on FirebaseFunctionsException catch (ex) {
      if (ex.code == 'already-exists') {
        throw MembershipException("You're already a member of this league.");
      } else {
        // Swallow up all other exceptions, while known, into a generalised statement for the user
        throw MembershipException(
          'Something went wrong trying to join the league. Please try again later.',
        );
      }
    }
  }

  Future<void> _assertNotAlreadyInLeague({required String leagueId}) async {
    final currentUserId = _authService.currentUser?.uid;

    if (currentUserId == null) {
      return;
    }

    final existingMembership = await _membershipsCollection
        .where('league_id', isEqualTo: leagueId)
        .where('user_id', isEqualTo: _authService.currentUser?.uid)
        .limit(1)
        .get();

    if (existingMembership.size > 0) {
      throw MembershipException("You're already a member of this league.");
    }
  }
}
