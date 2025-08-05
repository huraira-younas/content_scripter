part of 'user_bloc.dart';

abstract class UserEvent {}

final class SignUpEvent extends UserEvent {
  final String otp;
  final String name;
  final String email;
  final String password;
  final PhoneModel phone;

  SignUpEvent({
    required this.email,
    required this.otp,
    required this.name,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone.toJson(),
    };
  }
}

final class LoginEvent extends UserEvent {
  final String email;
  final String password;

  LoginEvent({
    required this.email,
    required this.password,
  });
}

final class GoogleSignInEvent extends UserEvent {
  final bool isRegister;

  GoogleSignInEvent({this.isRegister = false});
}

final class UpdateUserEvent extends UserEvent {
  final String? newEmail;
  final UserModel user;

  UpdateUserEvent({
    required this.user,
    this.newEmail,
  });
}

final class SetUserEvent extends UserEvent {
  final UserModel user;

  SetUserEvent({required this.user});
}

final class HandlePasswordEvent extends UserEvent {
  final String email;
  final String password;

  // To update password
  final String? oldPassword;

  HandlePasswordEvent({
    required this.email,
    required this.password,
    this.oldPassword,
  });
}

final class LogoutEvent extends UserEvent {}

final class SharedPrefEvent extends UserEvent {}
