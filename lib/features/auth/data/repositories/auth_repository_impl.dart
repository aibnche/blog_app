import 'package:blog/core/error/exceptions.dart';
import 'package:blog/core/error/failure.dart';
import 'package:blog/core/network/connection_checker.dart';
import 'package:blog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog/core/common/entities/user.dart';
import 'package:blog/features/auth/data/models/user_model.dart';
import 'package:blog/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

// this is the concrete implementation of the AuthRepository
// it relies on the AuthRemoteDataSource to perform the actual data operations
class AuthRepositoryImpl implements AuthRepository{
  final AuthRemoteDataSource remoteDataResource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl({
        required this.remoteDataResource,
        required this.connectionChecker
      });

  /*
    @ Future is used for asynchronous operations that will complete at some point in the future
    
    @ Either is a type that can hold one of two possible values,
      typically representing success (Right) or failure (Left).
  */
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
      if (! await (connectionChecker.isConnected)) {
        final session = remoteDataResource.currentUserSession;
        // no internet and no session
        if (session == null) {
          return Left(Failure('User not logged in !!'));
        }
        // no internet but have session
        return Right(UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: ''
          ));
      }
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
      if (! await (connectionChecker.isConnected)) {
        return Left(Failure('No internet connection'));
      }
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