import 'package:dartz/dartz.dart';

import 'string_validator_base.dart';

class NonEmptyStringValidator implements StringValidatorBase {
  @override
  Either<String, bool> isValid(String value) {
    if (value.isEmpty) {
      return Left('Cannot be empty');
    }

    return Right(true);
  }
}

class AuthValidators {
  final StringValidatorBase nameValidator = NonEmptyStringValidator();
  final StringValidatorBase emailValidator = NonEmptyStringValidator();
  final StringValidatorBase passwordValidator = NonEmptyStringValidator();
}
