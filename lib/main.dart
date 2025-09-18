import 'package:blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog/core/theme/theme.dart';
import 'package:blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog/features/auth/presentation/pages/signin_page.dart';
import 'package:blog/features/blog/presentation/pages/blog_page.dart';
import 'package:blog/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  runApp(
    /*
      @ Registers multiple BLoCs/Cubits at once into the widget tree.
      @ So you can access AppUserCubit and AuthBloc from any widget.
    */
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()), // <- THEN instantiation happens
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Check if user is logged in when the app starts

    /*
      @  read, gets the AuthBloc instance that is fully constructed with all the needed properties.
      @  add, Adds an event to the AuthBloc
    */
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
    /**
     * @  initState(): This runs when the app starts to automatically,
     *    check if the user is already logged in from a previous session,
     *    so the app can navigate to the appropriate screen (BlogPage vs SignInPage).
     */
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      /*
        @ The BlocSelector automatically knows the current state because it listens to the AppUserCubit. Here's how:

            1- Initial State: When "AppUserCubit" is created, it starts with "AppUserInitial()"
              < AppUserCubit() : super(AppUserInitial()); />

            2- State Changes: When the cubit emits a new state (like "emit(AppUserLoggedIn(user))" ),
              "BlocSelector" automatically receives the new state.

            3- Selector Function: The selector function runs every time the state changes
      */
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const BlogPage();
          }
          return const SignInPage();
        },
      ),
    );
  }
}

// cubits folder contains all the common cubits across all the features in our app,


/*

@ the state in BlocSelector<AppUserCubit, AppUserState, bool>
  is an instance of a class that extends AppUserState.
@ When you check state is AppUserLoggedIn, it means the current state is of type AppUserLoggedIn,
  which contains a User object (the logged-in user's data).

What does it mean ?

@ If state is AppUserLoggedIn is true, the user is logged in and their data
  is available in state.user.
@ If false, the user is not logged in (could be AppUserInitial or other states).

@ Can a state represent multiple states at the same time?
  No, a Cubit/Bloc can only have one active state at a time.


*/




/*
  @ Initial State: When "AppUserCubit" is created, it starts with "AppUserInitial()"
    < AppUserCubit() : super(AppUserInitial()); />

  @ State Changes: When the cubit emits a new state (like "emit(AppUserLoggedIn(user))" ),
    "BlocSelector" automatically receives the new state.

  @ Selector Function: The selector function runs every time the state changes:
*/