import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async' show StreamSubscription;
import 'dart:developer' show log;

enum InternetStatus { lost, wifi, mobile, vpn }

class InternetCubit extends Cubit<InternetStatus> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _stream;

  InternetCubit() : super(InternetStatus.lost) {
    _stream = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
    );
  }

  void _handleConnectivityChange(List<ConnectivityResult> event) {
    log(event.toString());
    switch (event[0]) {
      case ConnectivityResult.wifi:
        emit(InternetStatus.wifi);
        return;
      case ConnectivityResult.mobile:
        emit(InternetStatus.mobile);
        return;
      case ConnectivityResult.vpn:
        emit(InternetStatus.vpn);
        return;
      default:
        emit(InternetStatus.lost);
        return;
    }
  }

  @override
  Future<void> close() {
    _stream.cancel();
    return super.close();
  }
}
