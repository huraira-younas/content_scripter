part of 'timer_bloc.dart';

abstract class TimerEvent {}

class StartTimer extends TimerEvent {
  final int duration;

  StartTimer({required this.duration});
}

class TickingEvent extends TimerEvent {
  final int duration;

  TickingEvent({required this.duration});
}

class StopTimer extends TimerEvent {}

// ----------------------------------------------------------------
abstract class TimerState {}

final class TickingTimer extends TimerState {
  final int duration;

  TickingTimer({required this.duration});
}

final class TimerStopped extends TimerState {}
