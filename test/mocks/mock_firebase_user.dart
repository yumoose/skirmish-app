import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseUser extends Mock implements User {
  MockFirebaseUser({
    String uid = 'mock-user-id',
    String email = 'some-user-email',
  }) {
    when(this.uid).thenReturn(uid);
    when(this.email).thenReturn(email);
  }
}
