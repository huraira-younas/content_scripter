part of 'user_bloc.dart';

@immutable
class UserState {
  final bool loggedIn;
  final UserModel? user;
  final CustomState? error;
  final CustomState? loading;

  const UserState({
    this.user,
    this.error,
    this.loading,
    this.loggedIn = false,
  });
}

@immutable
class CustomState {
  final String title;
  final String message;

  const CustomState({
    required this.title,
    required this.message,
  });
}
