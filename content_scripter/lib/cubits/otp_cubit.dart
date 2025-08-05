import 'package:content_scripter/services/exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert' show jsonDecode;

enum OtpEvent { sent, sending, error, verified }

class OtpCubit extends Cubit<OtpState> {
  final _prefix = "${ApiRoutes.ip}/auth/api";
  OtpCubit() : super(OtpState());

  void sendOtp({required String email, String method = ""}) async {
    try {
      emit(OtpState(
        event: OtpEvent.sending,
        title: "Sending OTP",
        message: "Please wait...",
      ));

      final response = await ApiService.sendRequest(
        "$_prefix/send_otp",
        {
          'email': email,
          'method': method,
        },
      );
      final body = jsonDecode(response['body']);

      if (response['status'] != 200) throw body['error'];

      emit(OtpState(
        event: OtpEvent.sent,
        message: "OTP sent to $email",
      ));
    } catch (e) {
      emit(OtpState(
        event: OtpEvent.error,
        title: "OTP Error",
        message: e.toString(),
      ));
    }
  }

  void verifyOtp({required String email, required String otp}) async {
    try {
      emit(OtpState(
        event: OtpEvent.sending,
        title: "Verifying OTP",
        message: "Please wait...",
      ));

      final response = await ApiService.sendRequest(
        "$_prefix/verify_otp",
        {
          'email': email,
          'otp': otp,
        },
      );
      final body = jsonDecode(response['body']);

      if (response['status'] != 200) throw body['error'];

      emit(OtpState(
        event: OtpEvent.verified,
        message: "OTP Verified",
      ));
    } catch (e) {
      emit(OtpState(
        event: OtpEvent.error,
        title: "OTP Error",
        message: e.toString(),
      ));
    }
  }
}

final class OtpState {
  final OtpEvent event;
  final String message;
  final String title;

  OtpState({
    this.event = OtpEvent.sent,
    this.message = "",
    this.title = "",
  });
}
