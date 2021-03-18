import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skirmish/models/league.dart';

class LeagueService {
  late FirebaseFirestore firestore;

  LeagueService({FirebaseFirestore? firestore}) {
    this.firestore = firestore ?? FirebaseFirestore.instance;
  }

  Stream<Iterable<League>> leagues() {
    return firestore.collection('leagues').snapshots().map((leagues) {
      return leagues.docs.map((leagueDocument) {
        return League.fromSnapshot(
          id: leagueDocument.id,
          snapshot: leagueDocument.data()!,
        );
      });
    });
  }
}
