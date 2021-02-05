import 'package:cloud_firestore/cloud_firestore.dart';

class LeagueService {
  FirebaseFirestore firestore;

  LeagueService({FirebaseFirestore firestore}) {
    this.firestore = firestore ?? FirebaseFirestore.instance;
  }

  Stream<List<League>> leagues() {
    return firestore.collection('leagues').snapshots().map((leagues) {
      return leagues.docs.map((leagueDocument) {
        final leagueData = leagueDocument.data();

        return League(
          id: leagueDocument.id,
          name: leagueData['name'] as String,
        );
      }).toList();
    });
  }
}

class League {
  final String id;
  final String name;

  League({
    this.id,
    this.name,
  });
}
