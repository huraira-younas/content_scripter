import 'package:content_scripter/constants/app_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' show log;
import 'dart:async' show Timer;

class TimerCubit extends Cubit<Map<String, TimerState>> {
  TimerCubit() : super({});

  final _timers = <String, Timer?>{};
  final _duration = <String, int>{};

  int getTimeInSeconds(String key) => _duration[key] ?? 0;
  Timer? getTimer(String key) => _timers[key];
  String getText(String key) => AppUtils.formatTimeDuration(
        _duration[key] ?? 0,
      );

  void startGenTimer({
    Function()? onEnd,
    required String key,
    required DateTime endTime,
    bool isForceStart = false,
    required DateTime currentTime,
  }) {
    if (isForceStart) {
      _cancelTimer(key);
    }

    if (_timers[key]?.isActive ?? false) {
      return;
    }

    int remTimeInSec = endTime.difference(currentTime).inSeconds;

    if (remTimeInSec <= 0) {
      _cancelTimer(key);
      log("$key: Timer ended");
      onEnd?.call();
      return;
    }

    log("$key: Started Timer");

    _timers.putIfAbsent(key, () => null);
    _duration.putIfAbsent(key, () => 0);
    _timers[key] = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remTimeInSec <= 0) {
        _cancelTimer(key);
        onEnd?.call();
        return;
      }
      _duration[key] = --remTimeInSec;
      // log("$key: $remTimeInSec");
      _emit(key: key);
    });
  }

  void _emit({required String key}) {
    final duration = _duration[key];
    emit({
      ...state,
      key: TimerState(
        duration: duration,
        isRunning: duration != null,
        timer: _timers[key],
        key: key,
      ),
    });
  }

  void _cancelTimer(String key) {
    _timers[key]?.cancel();
    _duration.remove(key);
    _timers.remove(key);
    _emit(key: key);
  }

  void reset() {
    log("Reset Timers");
    _timers.forEach((key, value) => value?.cancel());
    _timers.clear();
    _duration.clear();
  }

  @override
  Future<void> close() {
    reset();
    return super.close();
  }
}

final class TimerState {
  final bool isRunning;
  final int? duration;
  final Timer? timer;
  final String key;

  TimerState({
    this.isRunning = false,
    this.key = "",
    this.duration,
    this.timer,
  });
}
