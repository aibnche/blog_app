import 'package:blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog/core/secrets/app_secrets.dart';
import 'package:blog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog/features/auth/domain/repository/auth_repository.dart';
import 'package:blog/features/auth/domain/usecases/current_user.dart';
import 'package:blog/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


/*

  @ When you register something with registerLazySingleton or registerFactory, it does not resolve the dependencies immediately.
    Instead, it stores the factory (or the singleton instance once created) for later.

  @ GetIt resolve all dependencies when "BlocProvider" actually requests serviceLocator<AuthBloc>(),
    by that time "AppUserCubit" has already been registered

  @ that what explain the behavior of registering "AuthBloc" before "AppUserCubit"
 */
final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  
  final supabase = await Supabase.initialize(
    url : AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  // Data source
  serviceLocator.registerFactory<AuthRemoteDataSource>( 
    () => AuthRemoteDataSourceImpl(
      supabaseClient: serviceLocator() // References supabase.client
    )
  );

  // Repository
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataResource: serviceLocator()
  ));

  // Use cases
  serviceLocator.registerFactory(
    () => UserSignUp(authRepository: serviceLocator())
  );

  serviceLocator.registerFactory(
    () => UserSignIn(authRepository: serviceLocator())
  );

  serviceLocator.registerFactory(
    () => CurrentUser(authRepository: serviceLocator())
  );
  // Bloc
  // only one instance of AuthBloc throughout the app
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userSignIn: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator()
      ),
      
  );


}