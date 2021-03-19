import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:skirmish/exceptions/membership_exception.dart';
import 'package:skirmish/models/membership.dart';
import 'package:skirmish/services/auth_service.dart';

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

  Future<Membership> joinLeague({required String leagueId}) async {
    await _assertNotAlreadyInLeague(leagueId: leagueId);

    // return _membershipsCollection.add()
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
      throw MembershipException('Already in league');
    }
  }
}
