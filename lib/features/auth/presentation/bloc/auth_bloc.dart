

// import 'dart:js_interop';

import 'package:blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog/core/usecase/usecase.dart';
import 'package:blog/core/common/entities/user.dart';
import 'package:blog/features/auth/domain/usecases/current_user.dart';
import 'package:blog/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';


/*
  @ Purpose: Handles authentication logic, e.g.:
      + Signing in
      + Signing up
      + Checking if the user is already logged in
      + Consumes use cases like CurrentUser, UserSignIn, etc.
      + Controls flow of auth-related events.
*/


// AuthBloc class that extends Bloc and manages authentication events and states
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  // Constructor with required parameters, That initializes the use cases
  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    })
    : _userSignUp = userSignUp,
      _userSignIn = userSignIn,
      _currentUser = currentUser,
      _appUserCubit = appUserCubit,
      super(AuthInitial()) {
    
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
      final res = await _currentUser(NoParams());

      res.fold(
        (failure) => emit(AuthFailure(message: failure.message)), 
        (user) => _emitAuthSuccess(user, emit)
      );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
      final res = await _userSignUp(UserSignUpParams(
        email: event.email,
        name: event.name,
        password: event.password));

      res.fold(
        (failure) => emit(AuthFailure(message: failure.message)), 
        (user) => _emitAuthSuccess(user, emit));
  }

  void _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
      final res = await _userSignIn(UserSignInParams(
        email: event.email,
        password: event.password));

      res.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (user) {
       
          // Use a logging framework instead of print
          debugPrint("user =======================");
          debugPrint("user from bloc: ${user.id}, ${user.email}, ${user.name}");
          debugPrint("user =======================");
          _emitAuthSuccess(user, emit);
       
  });
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}

// bloc and cubit are similar, but bloc is more powerful and complex
// cubit is simpler and easier to use
// Use bloc when you have complex state management needs
// Use cubit when you have simple state management needs
// Use bloc when you need to handle multiple events and states
// Use cubit when you have a single state

// bloc compose of events and states
// cubit compose of states and functions that emit states

// both used to communicate with UI layer
