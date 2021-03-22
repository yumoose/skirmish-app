class AuthException implements Exception {
  final String message;

  AuthException(this.message);
}

class MustBeLoggedInException extends AuthException {
  MustBeLoggedInException()
      : super('You must be logged in to perform this action');
}
