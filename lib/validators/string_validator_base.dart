import 'package:dartz/dartz.dart';

abstract class StringValidatorBase {
  Either<String, bool> isValid(String value);
}
