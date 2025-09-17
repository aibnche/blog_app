import 'package:blog/core/error/failure.dart';
import 'package:blog/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

// concerend with authentication status
abstract interface class AuthRepository {
  Future<Either<Failure, User>> singUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();
}