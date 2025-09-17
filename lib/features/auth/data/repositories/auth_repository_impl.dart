import 'package:blog/core/error/exceptions.dart';
import 'package:blog/core/error/failure.dart';
import 'package:blog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog/core/common/entities/user.dart';
import 'package:blog/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

// this is the concrete implementation of the AuthRepository
// it relies on the AuthRemoteDataSource to perform the actual data operations
class AuthRepositoryImpl implements AuthRepository{
  final AuthRemoteDataSource remoteDataResource;

  AuthRepositoryImpl({ required this.remoteDataResource});

  @override
  Future<Either<Failure, User>> singUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  })
  async {
    return _getUser(() async => await remoteDataResource.signUpWithEmailPassword(
      name: name,
      email: email,
      password: password));
  }


  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(() async => await remoteDataResource.signInWithEmailPassword(
      email: email,
      password: password
    ));
  }

  @override
  Future<Either<Failure, User>> currentUser() async{
    try{
      final user = await remoteDataResource.getCurrentUserData();
      if (user == null) {
        return Left(Failure('User not logged in'));
      }
      return Right(user);
    } on supa.AuthException catch(e){
      return Left(Failure(e.toString()));
    } on ServerException catch(e){
      return Left(Failure(e.toString()));
    }
  }


  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      final user = await fn();
      return Right(user);
    }
    on supa.AuthException catch (e) {
      return Left(Failure(e.message));
    }
    on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}