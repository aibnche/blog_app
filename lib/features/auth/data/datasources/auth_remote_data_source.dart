
import 'package:blog/core/error/exceptions.dart';
import 'package:blog/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// cancerned with remote data source operations for authentication
abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({ required String name,required String email,required String password,});

  Future<UserModel> signInWithEmailPassword({required String email,required String password,});

  Future<UserModel?> getCurrentUserData();
}





// bellow is the "concrete implementation" that rely on the above "contract"

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({ required this.supabaseClient});

  /*
      @ This getter provides access to the current user's authentication session, which contains:
        - User information
        - Access tokens
        - Session expiry details
        - Authentication state
  */
  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password})
  async{
    try{
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
        );
        if (response.user == null) {
          throw const ServerException('User is null');
        }
          // debugPrint("user3333333333=================");
          // debugPrint("User: ${response.user!.toJson()}");       // user details
          // debugPrint("Session: ${response.session?.toJson()}"); // tokens
          // debugPrint("user3333333 =======================");
        return UserModel.fromJson(response.user!.toJson());
    } catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password})
   async {
    try{
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
        });
        if (response.user == null) {
          throw const ServerException('User is null');
        }
        

        return UserModel.fromJson(response.user!.toJson());
    } catch(e){
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<UserModel?> getCurrentUserData() async {
    try{
      if (currentUserSession == null) {
        return null;
      }
      final user = await supabaseClient.from('profiles')
        .select()
        .eq('id', currentUserSession!.user.id);
      return UserModel.fromJson(user.first).copyWith(
        email: currentUserSession!.user.email,
      );
    } catch(e){
      throw ServerException(e.toString());
    }
  } 

}

