import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skirmish/models/membership.dart';

class MembershipService {
  late FirebaseFirestore firestore;

  MembershipService({FirebaseFirestore? firestore}) {
    this.firestore = firestore ?? FirebaseFirestore.instance;
  }

  Stream<Iterable<Membership>> memberships() {
    return firestore
        .collection('memberships')
        .snapshots()
        .map((membershipsQuery) {
      return membershipsQuery.docs.map(
        (membershipDocument) => Membership.fromSnapshot(
          id: membershipDocument.id,
          snapshot: membershipDocument.data()!,
        ),
      );
    });
  }
}
