import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get_it/get_it.dart';
import 'package:skirmish/exceptions/auth_exception.dart';
import 'package:skirmish/exceptions/membership_exception.dart';
import 'package:skirmish/models/membership.dart';
import 'package:skirmish/services/auth_service.dart';
import 'package:skirmish/utils/cloud_functions.dart';

enum MembershipAction {
  join,
  leave,
}

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

  Stream<Iterable<Membership>> leagueMemberships({
    required String leagueId,
  }) {
    return _firestore
        .collection('memberships')
        .where('league_id', isEqualTo: leagueId)
        .where('expired_at', isNull: true)
        .snapshots()
        .asyncMap(
          (snapshot) => snapshot.docs.map(
            (membershipDoc) => Membership.fromSnapshot(
              id: membershipDoc.id,
              snapshot: membershipDoc.data()!,
            ),
          ),
        );
  }

  Stream<bool> isMemberOfLeague({required String leagueId}) {
    final currentPlayerId = _authService.currentUser?.uid;

    if (currentPlayerId == null) {
      return Stream.value(false);
    }

    return _firestore
        .collection('memberships')
        .where('player_id', isEqualTo: _authService.currentUser?.uid)
        .where('league_id', isEqualTo: leagueId)
        .where('expired_at', isNull: true)
        .limit(1)
        .snapshots()
        .asyncMap((snapshot) {
      if (snapshot.docs.isEmpty) {
        return false;
      } else {
        final membershipDoc = snapshot.docs.first;
        return Membership.fromSnapshot(
          id: membershipDoc.id,
          snapshot: membershipDoc.data()!,
        ).isActive;
      }
    });
  }

  Future<void> updateMembership({
    required String leagueId,
    required MembershipAction action,
  }) async {
    switch (action) {
      case MembershipAction.join:
        await _joinLeague(leagueId: leagueId);
        break;
      case MembershipAction.leave:
        await _leaveLeague(leagueId: leagueId);
        break;
      default:
        throw MembershipException(
          'Functionality for , but it will be available shortly!',
        );
    }
  }

  Future<void> _assertNotAlreadyInLeague({required String leagueId}) async {
    final currentUserId = _authService.currentUser?.uid;

    if (currentUserId == null) {
      return;
    }

    final existingMembership = await _membershipsCollection
        .where('league_id', isEqualTo: leagueId)
        .where('player_id', isEqualTo: _authService.currentUser?.uid)
        .limit(1)
        .get();

    if (existingMembership.docs.isNotEmpty) {
      final membershipDoc = existingMembership.docs.first;
      final membership = Membership.fromSnapshot(
        id: membershipDoc.id,
        snapshot: membershipDoc.data()!,
      );

      if (membership.isActive) {
        throw MembershipException("You're already a member of this league.");
      }
    }
  }

  Future<void> _assertMemberOfLeague({required String leagueId}) async {
    final currentUserId = _authService.currentUser?.uid;

    if (currentUserId == null) {
      return;
    }

    final existingMembership = await _membershipsCollection
        .where('league_id', isEqualTo: leagueId)
        .where('player_id', isEqualTo: _authService.currentUser?.uid)
        .limit(1)
        .get();

    if (existingMembership.docs.isEmpty) {
      throw MembershipException("You're not a member of this league.");
    }
  }

  static final _joinLeagueFunction =
      cloudFunctions.httpsCallable('memberships-joinLeague');

  Future<void> _joinLeague({required String leagueId}) async {
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

  static final _leaveLeagueFunction =
      cloudFunctions.httpsCallable('memberships-leaveLeague');

  Future<void> _leaveLeague({required String leagueId}) async {
    try {
      await _authService.assertLoggedIn();
      await _assertMemberOfLeague(leagueId: leagueId);

      await _leaveLeagueFunction.call({
        'playerId': _authService.currentUser?.uid,
        'leagueId': leagueId,
      });
    } on MustBeLoggedInException catch (_) {
      throw MembershipException('You must be logged in to leave leagues.');
    } on FirebaseFunctionsException catch (ex) {
      if (ex.code == 'failed-precondition') {
        throw MembershipException("You're not a member of this league.");
      } else {
        // Swallow up all other exceptions, while known, into a generalised statement for the user
        throw MembershipException(
          'Something went wrong trying to join the league. Please try again later.',
        );
      }
    }
  }
}
