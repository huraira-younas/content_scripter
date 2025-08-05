import 'package:shared_preferences/shared_preferences.dart';
import 'package:content_scripter/models/phone_model.dart';
import 'package:content_scripter/models/user_model.dart';
import 'package:content_scripter/services/exports.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' show log;

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final _googleSignIn = GoogleSignIn();
  late final SharedPreferences _sp;

  final _userKey = 'user';
  UserModel? user;

  UserBloc() : super(const UserState()) {
    on<GoogleSignInEvent>(_googleSignInEvent);
    on<HandlePasswordEvent>(_handlePassword);
    on<SharedPrefEvent>(_getUserFromSP);
    on<UpdateUserEvent>(_updateUser);
    on<LogoutEvent>(_logoutUser);
    on<SignUpEvent>(_signUpUser);
    on<LoginEvent>(_loginUser);
    on<SetUserEvent>(_setUser);
  }

  Future<void> _googleSignInEvent(
    GoogleSignInEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      _emit(emit,
          loggedIn: false,
          loading: const CustomState(
            title: "Signin User",
            message: "please wait...",
          ));

      final data = await _googleSignIn.signIn();
      if (data != null) {
        await _parseInMongoDb(event: {
          "profileUrl": data.photoUrl ?? "",
          "name": data.displayName ?? "",
          "email": data.email,
          "password": data.id,
          "isGoogle": true,
        });
        _emit(emit, loggedIn: true);
        return;
      }
      _emit(emit);
    } catch (e) {
      await _googleSignIn.signOut();
      _emit(emit,
          loggedIn: false,
          error: CustomState(
            title: "Signin Error",
            message: e.toString(),
          ));
    }
  }

  Future<void> _parseInMongoDb({required Map<String, dynamic> event}) async {
    final response = await ApiService.sendRequest(ApiRoutes.signup, event);
    log(response.toString());

    final body = jsonDecode(response['body']);
    if (response['status'] != 200) throw body['error'];
    user = UserModel.fromJson(body['user']);
    await _sp.setString(_userKey, jsonEncode(user));
  }

  Future<void> _setUser(
    SetUserEvent event,
    Emitter<UserState> emit,
  ) async {
    log("Setting User...");
    await _sp.setString(_userKey, jsonEncode(event.user));
    user = event.user;
    _emit(emit, loggedIn: true);
  }

  Future<void> _handlePassword(
    HandlePasswordEvent event,
    Emitter<UserState> emit,
  ) async {
    // ? For update password
    final oldPassword = event.oldPassword;
    try {
      _emit(emit,
          loggedIn: oldPassword != null,
          loading: const CustomState(
            title: "Updating Password",
            message: "Please wait...",
          ));

      final response = await ApiService.sendRequest(ApiRoutes.updatePassword, {
        "email": event.email,
        "password": event.password,
        "oldPassword": oldPassword,
      });

      final body = jsonDecode(response['body']);
      if (response['status'] != 200) throw body['error'];

      _emit(emit, loggedIn: oldPassword != null);
    } catch (e) {
      _emit(emit,
          loggedIn: oldPassword != null,
          error: CustomState(
            title: "Error Updating Password",
            message: e.toString(),
          ));
    }
  }

  Future<void> _updateUser(
    UpdateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    final eventUser = event.user;
    try {
      _emit(emit,
          loggedIn: true,
          loading: const CustomState(
            title: "Updating User",
            message: "Please wait...",
          ));

      String profile = eventUser.profileUrl;
      if (user!.profileUrl != eventUser.profileUrl) {
        final oldProfile = user!.profileUrl;
        profile = await ApiService.uploadFile(
          filePath: eventUser.profileUrl,
          url: ApiRoutes.uploadFile,
          uid: user!.uid,
        );

        await ApiService.sendFormDataRequest(
          ApiRoutes.deleteFile,
          {'file_path': oldProfile},
        ).then((v) => log(v.toString()));
      }

      final updatedUser = eventUser.copyWith(profileUrl: profile);

      final response = await ApiService.sendRequest(ApiRoutes.updateUser, {
        'email': updatedUser.email,
        'newEmail': event.newEmail,
        'user': updatedUser.toJson(),
      });

      log(response.toString());
      final body = jsonDecode(response['body']);
      if (response['status'] != 200) throw body['error'];

      user = updatedUser.copyWith(email: event.newEmail);
      await _sp.setString(_userKey, jsonEncode(body));

      _emit(emit, loggedIn: true);
    } catch (e) {
      _emit(emit,
          loggedIn: true,
          error: CustomState(
            title: "Update Failed",
            message: e.toString(),
          ));
    }
  }

  Future<void> _getUserFromSP(
    SharedPrefEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      _sp = await SharedPreferences.getInstance();
      final data = _sp.getString(_userKey);
      if (data == null) {
        emit(const UserState());
        return;
      }
      final body = jsonDecode(data);
      log(data.toString());

      user = UserModel.fromJson(body);
      _emit(emit, loggedIn: true);
    } catch (e) {
      log(e.toString());
      _emit(emit,
          error: CustomState(
            title: "Register Failed",
            message: e.toString(),
          ));
    }
  }

  Future<void> _signUpUser(
    SignUpEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      _emit(emit,
          loading: const CustomState(
            title: "Registering User",
            message: "Please wait...",
          ));

      _parseInMongoDb(event: event.toJson());
      _emit(emit, loggedIn: true);
    } catch (e) {
      _emit(emit,
          error: CustomState(
            title: "Register Failed",
            message: e.toString(),
          ));
    }
  }

  Future<void> _loginUser(
    LoginEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      _emit(emit,
          loading: const CustomState(
            title: "Login User",
            message: "Please wait...",
          ));

      final response = await ApiService.sendRequest(ApiRoutes.login, {
        "password": event.password,
        "email": event.email,
      });

      final body = jsonDecode(response['body']);
      if (response['status'] != 200) throw body['error'];

      await _sp.setString(_userKey, jsonEncode(body['user']));
      user = UserModel.fromJson(body['user']);

      _emit(emit, loggedIn: true);
    } catch (e) {
      _emit(emit,
          error: CustomState(
            title: "Login Failed",
            message: e.toString(),
          ));
    }
  }

  Future<void> _logoutUser(LogoutEvent event, Emitter<UserState> emit) async {
    try {
      _emit(emit,
          loggedIn: true,
          loading: const CustomState(
            title: "Logging out",
            message: "Please wait...",
          ));

      await Future.delayed(const Duration(seconds: 2));
      await _googleSignIn.signOut();
      await _sp.remove(_userKey);

      _emit(emit);
    } catch (e) {
      _emit(emit,
          error: CustomState(
            title: "Logout Failed",
            message: e.toString(),
          ));
    }
  }

  void _emit(
    Emitter<UserState> emit, {
    bool loggedIn = false,
    CustomState? loading,
    CustomState? error,
  }) {
    emit(
      UserState(
        loggedIn: loggedIn,
        loading: loading,
        error: error,
        user: user,
      ),
    );
  }
}
