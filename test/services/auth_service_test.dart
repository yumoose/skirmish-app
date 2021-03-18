import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:skirmish/services/auth_service.dart';

import '../mocks/mock_firebase_auth.dart';
import '../mocks/mock_firebase_user.dart';
import '../mocks/mock_firestore.dart';

void main() {
  final mockFirebaseAuth = MockFirebaseAuth();
  final mockFirestore = MockFirestore();

  final authService = AuthService(
    firebaseAuth: mockFirebaseAuth,
    firestore: mockFirestore,
  );

  group('currentUser', () {
    test('returns the currently signed in user', () async {
      final mockFirebaseUser = MockFirebaseUser();
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);

      expect(authService.currentUser, equals(mockFirebaseUser));
    });

    test('when there is no user signed in', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      expect(authService.currentUser, isNull);
    });
  });

  group('isLoggedIn', () {
    test('is true if there is a user currently signed in', () async {
      final mockFirebaseUser = MockFirebaseUser();
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);

      expect(authService.isLoggedIn, isTrue);
    });

    test('is false if there is not a user currently signed in', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      expect(authService.isLoggedIn, isFalse);
    });
  });

  group('signOut', () {
    test('signs the user out', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer(
        (_) => Future.value(null),
      );

      await authService.signOut();
      verify(() => mockFirebaseAuth.signOut()).called(1);
    });
  });
}
