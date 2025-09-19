import 'package:blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog/core/secrets/app_secrets.dart';
import 'package:blog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog/features/auth/domain/repository/auth_repository.dart';
import 'package:blog/features/auth/domain/usecases/current_user.dart';
import 'package:blog/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blog/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/*

  @ When you register something with registerLazySingleton or registerFactory, it does not resolve the dependencies immediately.
    Instead, it stores the factory (or the singleton instance once created) for later.

  @ GetIt resolve all dependencies when "BlocProvider" actually requests serviceLocator<AuthBloc>(),
    by that time "AppUserCubit" has already been registered

  @ that what explain the behavior of registering "AuthBloc" before "AppUserCubit"
 */

/*
  RegisterSingleton & RegisterLazySingleton :
    Ensure there’s only one instance of the class in your whole app
    The difference is when that instance is created :
      -- registerSingleton -> instance throughout the app
                              (when you need the service right away)
      -- registerLazySingleton -> + instance created when first requested
                                  + It creates only one instance of the class (singleton).
                                  + (when you want to delay creation until it’s actually used)

  -- registerFactory -> + new instance created each time it's requested
                        + registerFactory would create a new BlogBloc instance every time it's requested
                          This would lose state when navigating between screens
                          Each screen would start with a fresh, empty state
*/

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBloc();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  // Data source (talks to Supabase)
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      supabaseClient: serviceLocator(), // References supabase.client
    ),
  );

  // Repository (handles logic)
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataResource: serviceLocator()),
  );

  // Use cases (business logic)
  serviceLocator.registerFactory(
    () => UserSignUp(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => UserSignIn(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => CurrentUser(authRepository: serviceLocator()),
  );
  // Bloc (state management)
  // only one instance of AuthBloc throughout the app
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userSignIn: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}

void _initBloc() {
  // Data source
  serviceLocator.registerFactory<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImpl(supabaseClient: serviceLocator()),
  );

  // Repository
  serviceLocator.registerFactory<BlogRepository>(
    () => BlogRepositoryImpl(blogRemoteDataSource: serviceLocator()),
  );

  // Usecases
  serviceLocator.registerFactory(
    () => UploadBlog(blogRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => GetAllBlogs(blogRepository: serviceLocator()),
  );

  // Bloc
  /*
    because we want maintain the state of the blog after navigating
    + Only one BlogBloc instance exists throughout the entire app lifecycle
    + When you navigate between screens, the same BlogBloc instance is used
  */
  serviceLocator.registerLazySingleton(
    () => BlogBloc(
      uploadBlog: serviceLocator(),
      getAllBlogs: serviceLocator(),
    )
  );
}
