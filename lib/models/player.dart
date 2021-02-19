import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  final String id;
  final String name;
  final String tag;

  Player({
    this.id,
    this.name,
    this.tag,
  });

  String get userId => id;

  static Player fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    final documentData = documentSnapshot.data();

    return Player(
      id: documentSnapshot.id,
      name: documentData['name'] as String,
      tag: documentData['tag'] as String,
    );
  }
}
