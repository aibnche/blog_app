import 'package:blog/core/common/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_user_state.dart';

// Cubit to manage the application user state
/* Passing sealed classes as states,
    so we can have multiple states,
    like initial, logged in, logged out, etc. */


/*
  @ Purpose: Holds the global user state — mainly whether the user is logged in or not.

  @ Output: Emits states like AppUserLoggedIn(user) or AppUserInitial().

  @ Used by UI: The UI (MyApp) listens to this cubit to decide which screen to show: BlogPage or SignInPage.
 */
class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserInitial());
    } else {
      emit(AppUserLoggedIn(user));
    } 
  }
}
