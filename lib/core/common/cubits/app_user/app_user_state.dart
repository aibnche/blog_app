part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}


final class AppUserLoggedIn extends AppUserState {
  final User user;

  AppUserLoggedIn(this.user);

}

// core cannot depend on features, so we cannot use User model here
// other features can extend this state if needed