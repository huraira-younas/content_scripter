import 'dart:async' show Timer;
import 'package:flutter_bloc/flutter_bloc.dart';
part 'timer_event.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Timer? _timer;

  TimerBloc() : super(TimerStopped()) {
    on<StartTimer>((event, emit) {
      _timer?.cancel();
      int duration = event.duration;
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          if (duration == 0) {
            timer.cancel();
            add(StopTimer());
          } else {
            add(TickingEvent(duration: duration));
            duration--;
          }
        },
      );
    });

    on<TickingEvent>((event, emit) {
      emit(TickingTimer(duration: event.duration));
    });

    on<StopTimer>((event, emit) {
      _timer?.cancel();
      emit(TimerStopped());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
